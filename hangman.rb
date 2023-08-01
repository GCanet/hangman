require 'json'

class Breaker
  attr_accessor :hangman

  def initialize(hangman)
    @hangman = hangman
  end

  def partida
    palabra_maquina
    dibujo_hangman(@hangman.vidas)
    puts @hangman.guess
    user_guess
  end

  def palabra_maquina
    fname = 'dictionary.txt'
    if @hangman.solucion.empty?
      @hangman.solucion = File.readlines(fname).select { |word| word.length > 5 && word.length < 12 }.sample.chomp.upcase
      puts "La máquina ya tiene palabra, su longitud es: #{hangman.solucion.length}."
      @hangman.guess = '_' * @hangman.solucion.length
      puts @hangman.solucion
    else
      puts "La máquina ya tiene una palabra guardada: #{@hangman.solucion}"
    end
  end

  def user_guess
    puts 'CONTIUNAR = C, GUARDAR Y SALIR = S(s/c)'
    answer = gets.chomp.downcase

    case answer
    when 'c'
      introducir_letra
    when 's'
      @hangman.save_game
      exit
    else
      puts 'Entrada inválida. Por favor, pulsa S o N.'
    end
  end

  def introducir_letra
    puts 'Introduzca una letra:'
    @hangman.guess = gets.chomp.upcase.split('')
    comprobacion
  end

  def comprobacion
    if @hangman.guess == @hangman.solucion
      puts 'Tenemos un ganador!!'
      @hangman.playinicial
    else
      puts 'El usuario pierde una vida.'
      vida_menos
    end
  end

  def vida_menos
    @hangman.vidas -= 1
    dibujo_hangman(@hangman.vidas)
    user_guess
  end

  def dibujo_hangman(vidas)
    hangman = [
      [
        '  ________',
        '  |      |',
        '  |       ',
        '  |       ',
        '  |       ',
        ' _|_',
        '|   |______',
        '|__________|'
      ],
      [
        '  ________',
        '  |      |',
        '  |      O',
        '  |       ',
        '  |       ',
        ' _|_',
        '|   |______',
        '|__________|'
      ],
      [
        '  ________',
        '  |      |',
        '  |      O',
        '  |      | ',
        '  |       ',
        ' _|_',
        '|   |______',
        '|__________|'
      ],
      [
        '  ________',
        '  |      |',
        '  |      O',
        '  |     /| ',
        '  |       ',
        ' _|_',
        '|   |______',
        '|__________|'
      ],
      [
        '  ________',
        '  |      |',
        '  |      O',
        '  |     /|\\',
        '  |       ',
        ' _|_',
        '|   |______',
        '|__________|'
      ],
      [
        '  ________',
        '  |      |',
        '  |      O',
        '  |     /|\\',
        '  |     / ',
        ' _|_',
        '|   |______',
        '|__________|'
      ],
      [
        '  ________',
        '  |      |',
        '  |      O',
        '  |     /|\\',
        '  |     / \\',
        ' _|_',
        '|   |______',
        '|__________|'
      ]
    ]

    hangman[vidas].each do |line|
      puts line
    end

    if vidas.zero?
      puts 'Game over! Te has quedado sin vidas!!'
      @hangman.playinicial
    end
  end
end

class Hangman
  attr_accessor :guess, :solucion, :vidas

  def initialize
    @breaker = Breaker.new(self)
    @guess = ''
    @solucion = ''
    @vidas = 6
  end

  def playinicial
    loop do
      puts 'ADIVINAR = A, LOAD GAME = C, EXIT = S:'
      answer = gets.chomp.downcase

      case answer
      when 'a'
        vidas = 6
        puts '----------------------'
        puts '|      hangman       |'
        puts '----------------------'
        puts 'Empieza el juego, tú adivinas!'
        @breaker.partida
      when 'c'
        puts 'Cargando partida...'
        load_game
      when 's'
        puts 'Cerrando juego.'
        exit
      else
        puts 'Entrada inválida. Por favor, pulsa A, C o S.'
      end
    end
  end

  def save_game
    game_data = {
      guess: @guess,
      solucion: @solucion,
      vidas: @vidas
    }
    File.open('saved.json', 'w') do |file|
      file.write(JSON.dump(game_data))
    end
  end

  def load_game
    if File.exist?('saved.json')
      game_data = JSON.parse(File.read('saved.json'))
      @guess = game_data['guess']
      @solucion = game_data['solucion']
      @vidas = game_data['vidas']
      @breaker.partida
    else
      puts 'No se encontró ninguna partida guardada.'
    end
  end
end

new_game = Hangman.new
new_game.playinicial
