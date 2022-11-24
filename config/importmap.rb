# Pin npm packages by running ./bin/importmap

pin 'application', preload: true

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin 'turbolinks_events'

pin 'bootstrap',  to: 'bootstrap.bundle.js'

pin 'jquery',     to: 'jquery3.min.js', preload: true
pin 'jquery_ujs', to: 'jquery_ujs.js',  preload: true
pin 'jquery-ui/widgets/autocomplete', to: 'jquery-ui/widgets/autocomplete.js', preload: true

pin_all_from 'vendor/javascript/moment',     under: 'moment'
pin_all_from 'vendor/javascript/codemirror', under: 'codemirror'

pin 'codemirror',               to: 'codemirror/codemirror'
pin '@codemirror/autocomplete', to: 'codemirror/@codemirror--autocomplete.js'
pin '@codemirror/commands',     to: 'codemirror/@codemirror--commands.js'
pin '@codemirror/language',     to: 'codemirror/@codemirror--language.js'
pin '@codemirror/lint',         to: 'codemirror/@codemirror--lint.js'
pin '@codemirror/search',       to: 'codemirror/@codemirror--search.js'
pin '@codemirror/state',        to: 'codemirror/@codemirror--state.js'
pin '@codemirror/view',         to: 'codemirror/@codemirror--view.js'
pin '@lezer/common',            to: 'codemirror/@lezer--common.js'
pin '@lezer/highlight',         to: 'codemirror/@lezer--highlight.js'
pin 'crelt',                    to: 'codemirror/crelt'
pin 'style-mod',                to: 'codemirror/style-mod'
pin 'w3c-keyname',              to: 'codemirror/w3c-keyname'
pin 'codemirror/mode/python'
pin 'codemirror/mode/ruby'
pin 'codemirror/mode/shell'
pin 'codemirror/mode/sql'

pin 'editor'
pin 'helps'
pin 'issues_board'
pin 'objects'
pin 'rules'
pin 'servers'
pin 'trix_configuration'

pin 'daterangepicker'
pin 'metis_menu'
pin 'jquery-slimscroll'
pin 'hyper'

pin 'apexcharts'
pin 'ajax'
pin 'autocomplete'
pin 'clipboard'
pin 'date_pickers'
pin 'dynamic_form'
pin 'filters'
pin 'console'
pin 'data_links'

pin 'trix'
pin '@rails/actiontext', to: 'actiontext.js'

pin 'consumer'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
