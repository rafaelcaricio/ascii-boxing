# encoding: utf-8

module ASCIIBoxing

  LEFT_PLAYER_SPRITES = {
    normal: ['  ##     ',
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

    punching: 
            ['  ##     ',
             '  @@     ',
             ' {==}    ',
             '  ||     ',
             '  (( ===@',
             ' |  |    ',
             ' |  |@   ',
             ' |  |    ',
             ' ||||    ',
             ' || ==   ',
             '  ==     ']
  }

  RIGHT_PLAYER_SPRITES = {

    normal: ['     ##  ',
             '     @@  ',
             '    {==} ',
             '     ||  ',
             '  @=/  \ ',
             '   @===))',
             '    |  | ',
             '    |  | ',
             '    |||| ',
             '   == || ',
             '     ==  '],

    punching: 
            ['     ##  ',
             '     @@  ',
             '    {==} ',
             '     ||  ',
             '@=== ))  ',
             '    |  | ',
             '   @|  | ',
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
      @animation_stack = []
      @left_player = Player.new(LEFT_PLAYER_SPRITES, 10, 10, width)
      @right_player = Player.new(RIGHT_PLAYER_SPRITES, 40, 10, width)
      @objects = [@left_player, @right_player]
      @sleep_time = 0.1
      @exit_message = 'Bye!'
      @textbox_content = 'Running...'
    end

    def tick
      if action = @animation_stack.shift
        self.send(action)
      end

      if @left_player.punching? and @left_player.x >= @right_player.x - 9
        @right_player.demage
      end

      if @right_player.punching? and @right_player.x >= @left_player.x + 9
        @left_player.demage
      end

      left_player_lifebar = '#' * @left_player.life
      right_player_lifebar = '#' * @right_player.life
      @textbox_content = "LEFT PLAYER [%-10s] - [%10s] RIGHT PLAYER" % [left_player_lifebar, right_player_lifebar]

      if @left_player.dead? and @right_player.dead?
        @exit_message = 'HEY GUYS YOU SHOLD PLAY AGAIN... O.o'
        exit
      else if @left_player.dead?
            @exit_message = 'RIGHT PLAYER WINS!!!!!!'
            exit
          else if @right_player.dead?
                @exit_message = 'LEFT PLAYER WINS!!!!!!'
                exit
              end
          end
      end
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

    def left_punch
      @left_player.punch
    end

    def left_normal
      @left_player.normal
    end

    def left_player_move_left
      @left_player.move_left
    end

    def left_player_move_right
      @left_player.move_right(@right_player.x - 9)
    end

    def left_player_punch
      unless @animation_stack.include?(:left_punch)
        [:left_punch, :left_punch, :left_punch, :left_punch, :left_normal].each{ |action| @animation_stack.push(action) }
      end
    end

    def right_punch
      @right_player.punch
    end

    def right_normal
      @right_player.normal
    end

    def right_player_move_left
      @right_player.move_left(@left_player.x + 9)
    end

    def right_player_move_right
      @right_player.move_right
    end

    def right_player_punch
      unless @animation_stack.include?(:right_punch)
        [:right_punch, :right_punch, :right_punch, :right_punch, :right_normal].each{ |action| @animation_stack.push(action) }
      end
    end

    def exit
      Kernel.exit
    end
  end

  class GameObject
    attr_accessor :x, :y, :color, :texture

    def initialize(sprites, x, y, board_length)
      @sprites = sprites
      @x = x
      @y = y
      @board_length = board_length
    end
  end

  class Player < GameObject
    attr_accessor :life

    def initialize(sprites, x, y, board_length)
      super(sprites, x, y, board_length)
      @color = Curses::COLOR_RED
      @life = 10
      normal
    end

    def demage
      if @life > 0
        @life -= 1
      end
    end

    def dead?
      @life <= 0
    end

    def normal
      @texture = @sprites[:normal]
    end

    def punch
      @texture = @sprites[:punching]
    end

    def punching?
      @texture == @sprites[:punching]
    end

    def move_right(limit=nil)
      if limit == nil
        limit = @board_length - 11
      end
      if @x < limit
        @x += 1
      end
    end

    def move_left(limit=2)
      if @x > limit
        @x -= 1
      end
    end
  end

end
