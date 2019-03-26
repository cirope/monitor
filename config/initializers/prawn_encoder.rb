# frozen_string_literal: true

class Prawn::PrawnEncoder < CodeRay::Encoders::Encoder
  register_for :to_prawn

  COLORS = {
    default:           '666666',
    comment:           '999988',
    constant:          '008080',
    instance_variable: '008080',
    integer:           '009999',
    float:             '009999',
    inline_delimiter:  'DD1144',
    keyword:           '000000',
    method:            '008888',
    string:            'DD2200',
    symbol:            '990073'
  }

  STYLES = {
    default:  [],
    comment:  [:italic],
    keyword:  [:bold],
    class:    [:bold],
    function: [:bold]
  }

  def setup options
    super

    @out  = []
    @open = []
  end

  def text_token text, kind
    color  = COLORS[kind] || COLORS[@open.last] || COLORS[:default]
    styles = STYLES[kind] || STYLES[:default]

    @out << { text: text, color: color, styles: styles }
  end

  def begin_group kind
    @open << kind
  end

  def end_group kind
    @open.pop
  end
end
