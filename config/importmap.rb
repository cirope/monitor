# Pin npm packages by running ./bin/importmap

pin 'application', preload: true

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin 'turbolinks_events'

pin '@popperjs/core', to: 'popper.js',        preload: true
pin 'bootstrap',      to: 'bootstrap.min.js', preload: true

pin 'jquery',     to: 'jquery3.min.js', preload: true
pin 'jquery_ujs', to: 'jquery_ujs.js',  preload: true
pin 'jquery-ui/widgets/autocomplete', to: 'jquery-ui/widgets/autocomplete.js', preload: true

pin_all_from 'vendor/javascript/moment',     under: 'moment'
pin_all_from 'vendor/javascript/codemirror', under: 'codemirror'

pin 'editor'
pin 'helps'
pin 'issues_board'
pin 'objects'
pin 'drives'
pin 'rules'
pin 'servers'
pin 'trix_configuration'

pin 'daterangepicker'

pin 'hyper-config'
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
pin '@rails/activestorage', to: 'activestorage.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'

pin 'direct_upload', to: 'direct_upload.js'
