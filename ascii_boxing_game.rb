# encoding: utf-8

module ASCIIBoxing

  PLAYER_SPRITES = {
    right:  ['  ##     ',
             '  @@     ',
             ' {==}    ',
             '  ||     ',
             ' /  \=@  ',
             '((===@   ',
             ' |  |    ',
             ' |  |    ',
             ' ||||    ',
             ' || ==   ',
             '  ==     '],

    left:   ['     ##  ',
             '     @@  ',
             '    {==} ',
             '     ||  ',
             '  @=/  \ ',
             '   @===))',
             '    |  | ',
             '    |  | ',
             '    |||| ',
             '   == || ',
             '     ==  ']
  }

  class Game
    attr_accessor :exit_message, :textbox_content, :objects, :input_map, :sleep_time

    def initialize(width, heigth)
      @width = width
      @heigth = heigth
      @left_player = Player.new(:right, 10, 10)
      @right_player = Player.new(:left, 40, 10)
      @objects = [@left_player, @right_player]
      @sleep_time = 0.05
      @exit_message = 'Bye!'
      @textbox_content = 'Running...'
    end

    def tick
    end

    def wait?
    end

    def input_map
      {
        ?a => :left_player_move_left,
        ?s => :left_player_move_right,
        ?d => :left_player_punch,
        ?j => :right_player_move_left,
        ?k => :right_player_move_right,
        ?l => :right_player_punch,
        ?q => :exit
      }
    end

    def left_player_move_left
      @textbox_content = 'left player <<<'
    end

    def left_player_move_right
      @textbox_content = 'left player >>>'
    end

    def left_player_punch
      @textbox_content = 'left player ===@'
    end

    def right_player_move_left
      @textbox_content = 'right player <<<'
    end

    def right_player_move_right
      @textbox_content = 'right player >>>'
    end

    def right_player_punch
      @textbox_content = 'right player ===@'
    end

    def exit
      Kernel.exit
    end
  end

  class GameStack

  end

  class GameObject
    attr_accessor :x, :y, :color, :texture

    def initialize(x, y)
      @x = x
      @y = y
    end
  end

  class Player < GameObject
    def initialize(sprite, x, y)
      super(x, y)
      @color = Curses::COLOR_RED
      @texture = PLAYER_SPRITES[sprite]
    end
  end

end
