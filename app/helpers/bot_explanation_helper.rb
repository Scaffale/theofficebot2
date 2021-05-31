# Manage to handle long eplanation messages
module BotExplanationHelper
  KNOWN_FILTERS = {
    'ad' => 'Arrested Development, s01 ita',
    'agg' => 'Aldo Giovanni e Giacomo: Tre uomini ed una gamba',
    'fi' => "Le follie dell'imperatore, ita (sottotitoli per bambini)",
    'fj' => 'Frankenstein Junior, ita (sottotitoli tradotti)',
    'gm' => 'Get Smart (Agente Smart)',
    'lct' => 'Lo chiamavano Trinità',
    'ps' => 'Pallottola spuntata, trilogia, ita eng',
    'scr' => 'Scrubs, s01 ita, s01/04 eng',
    'tbb' => 'The Blues Brothers, ita',
    'tlotr' => 'Il Signore degli Anelli, trilogia'
  }.freeze

  def explanation
    "Funziono __inline__, quindi comincia a scrivere @plot_twist_bot e se vuoi cercare qualcosa scrivi pure.\n
    Puoi usare le opzioni:\n
    -b NUMERO, taglia il video N secondi indietro\n
    -a NUMERO, taglia il video N secondi avanti\n
    -f FILTRO, cerca solo in determinati file
    "
  end

  def list_of_filters
    file_filters = Sentence.group(:file_filter).select(:file_filter).map(&:file_filter)
    "Lista dei filtri:\n
    #{file_filters.map { |e| "#{e} -> #{KNOWN_FILTERS[e] || '🤷‍♂️'}\n" }.join}
    "
  end
end
