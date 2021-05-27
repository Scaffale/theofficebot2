# Create find query history
module HistoryQueryHelper
  include QueryHelper

  def update_history_query(query)
    qh = find_query(query)
    if qh.nil?
      create_query(query)
    else
      qh.increment!(:hits)
    end
  end

  def find_query(query)
    QueryHistory.where(search_params(query)).first
  end

  def find_or_create_query_sanitized(query)
    qh = QueryHistory.where(query_only_text(query)).first
    return qh if qh

    QueryHistory.create(query_only_text(query).merge({ hits: 1 }))
  end

  def create_query(query)
    QueryHistory.create(search_params(query).merge({ hits: 1 }))
  end

  def search_params(query)
    purged_query = purge_query(query)
    { text: purged_query[0].join(' '),
      time_after: purged_query[1][:delta_after],
      time_before: purged_query[1][:delta_before] }
  end

  def query_only_text(query)
    { text: purge_query(query)[0].join(' '),
      time_after: 0,
      time_before: 0 }
  end
end
