# frozen_string_literal: true

module EditorHelper
  def editor_phrases
    {
      'All'                                 => t('editor.all'),
      'No'                                  => t('no'),
      'Replace all:'                        => t('editor.replace_all'),
      'Replace with:'                       => t('editor.replace_with'),
      'Replace:'                            => t('editor.replace'),
      'Replace?'                            => t('editor.replace_confirmation'),
      'Search:'                             => t('editor.search'),
      'Stop'                                => t('editor.stop'),
      'With:'                               => t('editor.with'),
      'Yes'                                 => t('yes'),
      '(Use /re/ syntax for regexp search)' => t('editor.regex_hint')
    }
  end
end
