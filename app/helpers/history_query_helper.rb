module HistoryQueryHelper
  include QueryHelper

  def update_history_query(query)
    purged_query = purge_query(query)
    search_params = { text: purged_query[0].join(' '), time_after: purged_query[1][:delta_after],
                      time_before: purged_query[1][:delat_before] }
    qh = QueryHistory.find_by(search_params)
    if qh.nil?
      QueryHistory.create(search_params.merge({ hits: 1 }))
    else
      qh.increment!(:hits)
    end
  end
end
