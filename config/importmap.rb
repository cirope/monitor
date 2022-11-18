# Pin npm packages by running ./bin/importmap

pin 'application', preload: true

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin 'turbolinks_events'

pin 'bootstrap',  to: 'bootstrap.bundle.min.js'

pin 'jquery',     to: 'jquery3.min.js', preload: true
pin 'jquery_ujs', to: 'jquery_ujs.js',  preload: true
pin 'jquery-ui/widgets/autocomplete', to: 'jquery-ui/widgets/autocomplete.js',  preload: true

pin_all_from 'vendor/javascript/moment',     under: 'moment'
pin_all_from 'vendor/javascript/codemirror', under: 'codemirror'

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
