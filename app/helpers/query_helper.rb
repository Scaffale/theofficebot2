# Helper used to extract complex queries
module QueryHelper
  def search_sentence(query, offset = 0)
    purged_query, extra_params = purge_query(query)
    Rails.logger.info "QUERY: #{purged_query}, params: #{extra_params}"
    [build_query(purged_query, 3, offset, file_filter: extra_params[:file_filter]), extra_params]
  end

  def search_sentence_count(query)
    purged_query, = purge_query(query)
    build_query(purged_query, Sentence.all.count).count
  end

  def extract_option(query, letter)
    regex = /-#{letter} ?-?\d+.?\d*/
    return [query, 0] unless query.match?(regex)

    numb_str = query.scan(regex).first
    query = query.sub(numb_str, '')
    number = numb_str.sub("-#{letter}", '').to_f
    [query, number]
  end

  def extract_filter(query, filter)
    regex = /-#{filter} ?\w+/
    return [query, nil] unless query.match?(regex)

    value_str = query.scan(regex).first
    query = query.sub(value_str, '').strip
    value = value_str.sub("-#{filter}", '').strip
    [query, value]
  end

  def purge_query(query)
    query, before_time = extract_option(query, 'b')
    query, after_time = extract_option(query, 'a')
    query, file_filter = extract_filter(query, 'f')
    after_time = (after_time + before_time).round(2)
    query = query.gsub(/\W/, ' ')
    [split_text(query), { delta_before: before_time, delta_after: after_time, file_filter: file_filter }]
  end

  def sanitize(query)
    query, = extract_option(query, 'b')
    query, = extract_option(query, 'a')
    query, = extract_filter(query, 'f')
    query.gsub(/\W/, ' ')
  end

  def split_text(query)
    query.downcase.split.sort.uniq
  end

  def build_query(query, limit, offset = 0, file_filter: nil)
    choosen = build_query_choosen_results(query: query, limit: limit, offset: offset)
    limit -= choosen.count

    res = if file_filter.present?
            Sentence.where(file_filter: file_filter)
          else
            Sentence.all
          end
    res = build_query_general(res: res, query: query, limit: limit, offset: offset)
    (choosen + res)
  end

  def build_query_choosen_results(query: [], limit: 10, offset: 0)
    build_query_general(res: ChoosenResult.all, query: query, limit: limit, offset: offset)
  end

  def build_query_general(res:, query: [], limit: 10, offset: 0)
    query.each do |q|
      res = res.where('LOWER(text) LIKE ?', "%#{q}%")
    end
    res.offset(offset).limit(limit)
  end
end
