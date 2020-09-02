# Helper used to extract complex queries
module QueryHelper
  include ActiveRecord::Sanitization::ClassMethods

  def search_sentence(query, offset = 0)
    purged_query, extra_params = purge_query(query)
    Rails.logger.info "QUERY: #{purged_query}, params: #{extra_params}"
    [build_query(purged_query, 10, offset), extra_params]
  end

  def search_sentence_count(query)
    purged_query, _extra_params = purge_query(query)
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

  def extract_number(query)
    query.scan(/(?<=-\w) ?\d+/).first.to_i
  end

  def purge_query(query)
    query, before_time = extract_option(query, 'b')
    query, after_time = extract_option(query, 'a')
    query = query.sub('  ', ' ')
    [split_text(query), { delta_before: before_time, delta_after: after_time }]
  end

  def split_text(query)
    query.split.map { |q| sanitize_sql_like(q.downcase) }
  end

  def build_query(query, limit_number, offset = 0)
    res = Sentence.all
    query.each do |q|
      res = res.where('LOWER(text) LIKE ?', "%#{q}%")
    end
    return res.offset(offset).limit(limit_number)
  end
end
