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
    else
      puts "La máquina ya tiene una palabra guardada: #{@hangman.solucion}"
    end
  end

  def user_guess
    puts 'GUARDAR Y SALIR? (y/n)'
    answer = gets.chomp.downcase

    case answer
    when 'n'
      introducir_letra
    when 'y'
      puts '.'
      puts '..'
      puts '...'
      puts '....'
      puts '.....Guardando partida'
      @hangman.save_game
      exit
    else
      puts 'Letra erronea, introduzca (Y)es o (N)o'
      user_guess
    end
  end

  def introducir_letra
    puts "Letras utilizadas: #{@hangman.used_letters}"
    puts 'Introduzca una letra:'
    letter = gets.chomp.upcase

    if @hangman.used_letters.include?(letter)
      puts 'Esta letra ya ha sido utilizada.'
    else
      @hangman.used_letters << letter
      @hangman.solucion.chars.each_with_index do |lett, index|
        if lett == letter
          @hangman.guess[index] = lett
        end
      end
    end
    if @hangman.solucion == @hangman.guess
      puts '¡Tenemos un ganador!'
      @hangman.playinicial
    elsif @hangman.solucion.chars.include?(letter)
      puts '¡Adivinaste una letra correctamente!'
      user_guess
    else
      puts 'El usuario pierde una vida.'
      vida_menos
    end
  end

  def vida_menos
    @hangman.vidas -= 1
    dibujo_hangman(@hangman.vidas)
    puts "*[ #{@hangman.guess} ]*"
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
  attr_accessor :guess, :solucion, :vidas, :used_letters

  def initialize
    @breaker = Breaker.new(self)
    @guess = ''
    @solucion = ''
    @vidas = 6
    @used_letters = []
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
        puts '.'
        puts '..'
        puts '...'
        puts '....'
        puts '.....Cargando partida'
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
      vidas: @vidas,
      used_letters: @used_letters
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
      @used_letters = game_data['used_letters']
      @breaker.partida
    else
      puts 'No se encontró ninguna partida guardada.'
    end
  end
end

new_game = Hangman.new
new_game.playinicial
