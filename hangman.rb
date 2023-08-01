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
      puts 'Para adivinar palabras pulsa A, para cargar una partida pulsa C, para salir pulsa S (a/s):'
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
    yaml = YAML.dump(self)
    game_file = GameFile.new('saved.yaml')
    game_file.write(yaml)
  end

  def load_game
    game_file = GameFile.new('saved.yaml')
    yaml = game_file.read
    loaded_game = YAML.load(yaml)
    self.guess = loaded_game.guess
    self.solucion = loaded_game.solucion
    self.vidas = loaded_game.vidas
    @breaker.partida
  end
end

class Breaker
  attr_accessor :hangman

  def initialize(hangman)
    @hangman = hangman
  end

  def partida
    dibujo_hangman(@hangman.vidas)
    palabra_maquina
    user_guess
  end

  def palabra_maquina
    fname = 'dictionary.txt'
    @hangman.solucion = File.readlines(fname).select { |word| word.length > 5 && word.length < 12 }.sample.chomp.upcase
    puts "La máquina ya tiene palabra, su longitud es: #{hangman.solucion.length}."
    @hangman.guess = '_' * @hangman.solucion.length
    puts @hangman.solucion
  end

  def user_guess
    puts 'Si quieres guardar y salir pulsa S, si quieres continuar pulsa C (s/c)'
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

    if vidas == 0
      puts 'Game over! Te has quedado sin vidas!!'
      @hangman.playinicial
    end
  end
end

class GameFile
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def write(data)
    File.open(@filename, 'w') do |file|
      file.write(data)
    end
  end

  def read
    File.read(@filename)
  end
end

new_game = Hangman.new
new_game.playinicial
