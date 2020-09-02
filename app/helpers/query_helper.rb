# Helper used to extract complex queries
module QueryHelper

  def search_sentence(query)
    purged_query, extra_params = purge_query(query)
    Sentence.where('LOWER(text) LIKE LOWER(?)', "%#{sanitize_sql_like(query)}%").limit(10)
  end

  def search_sentence_count(query)
    Sentence.where('LOWER(text) LIKE LOWER(?)', "%#{sanitize_sql_like(query)}%").count
  end

  def extract_option(query, letter)
    numb_str = query.scan(/-#{letter} ?\d+/).first
    byebug
    query = query.sub(numb_str, '')
    [query, numb_str]
  end

  def extract_number(query)
    query.scan(/(?<=-\w) ?\d+/).first.to_i
  end

  def purge_query(query)
    query, before_time = extract_option(query, 'b')
    query, after_time = extract_option(query, 'a')
    before_time = extract_number(before_time)
    after_time = extract_number(after_time)
    [query, {before: before_time, after: after_time}]
  end

end
