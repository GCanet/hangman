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
      puts "Machine has found a word to guess, length: #{@hangman.solucion.length}."
      @hangman.guess = '_' * @hangman.solucion.length
    else
      puts @hangman.mensajes[:palabr_guard]
    end
  end

  def user_guess
    puts @hangman.mensajes[:guard_salir]
    answer = gets.chomp.downcase

    case answer
    when 'n'
      introducir_letra
    when 'y'
      puts '.'
      puts '..'
      puts '...'
      puts '....'
      puts @hangman.mensajes[:guard_part]
      @hangman.save_game
      exit
    else
      puts @hangman.mensajes[:entr_anvalid]
      user_guess
    end
  end

  def introducir_letra
    puts @hangman.mensajes[:letras_utilizadas] + " #{@hangman.used_letters}"
    puts @hangman.mensajes[:introducir_letra]
    letter = gets.chomp.upcase

    if @hangman.used_letters.include?(letter)
      puts @hangman.mensajes[:letra_repetida]
    else
      @hangman.used_letters << letter
      @hangman.solucion.chars.each_with_index do |lett, index|
        if lett == letter
          @hangman.guess[index] = lett
        end
      end
    end
    if @hangman.solucion == @hangman.guess
      dibujo_hangman(@hangman.vidas)
      puts "*[ #{@hangman.guess} ]*"
      puts @hangman.mensajes[:ganador]
      @hangman.playinicial
    elsif @hangman.solucion.chars.include?(letter)
      dibujo_hangman(@hangman.vidas)
      puts "*[ #{@hangman.guess} ]*"
      puts @hangman.mensajes[:adivinaste_letra]
      user_guess
    else
      puts @hangman.mensajes[:pierde_vida]
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
      puts @hangman.mensajes[:gmee_ovr]
      @hangman.playinicial
    end
  end
end

class Hangman
  attr_accessor :guess, :solucion, :vidas, :used_letters, :mensajes

  def initialize
    @breaker = Breaker.new(self)
    @guess = ''
    @solucion = ''
    @vidas = 6
    @used_letters = []
    @mensajes = {}
  end

  def lang_inicial
    puts '1 = English / 2 = Spanish'
    awnser = gets.chomp.downcase

    case awnser
    when '1'
      mensajes = {
        letras_utilizadas: 'Used letters:',
        introducir_letra: 'Enter a letter:',
        letra_repetida: 'This letter has already been used.',
        ganador: 'We have a winner!',
        adivinaste_letra: 'You guessed a letter correctly!',
        pierde_vida: 'The user loses a life.',
        gmee_ovr: 'Game Over! You have no more lifes!',
        mensaje_inicial: 'PLAY = A, LOAD GAME = C, EXIT = S:',
        empieza_juego: 'Game start, you are guessing!',
        no_partida: 'We did not find any saved game',
        load_game: '.....Loading Game',
        closing_game: 'Closing game',
        entr_invalida: 'Incorrect awnser. Please, push A, C or S.',
        guard_salir: 'SAVE AND EXIT? (y/n)',
        guard_part: '.....Saving game',
        entr_anvalid: 'Incorrect awnser. Please, push (Y)es o (N)o',
        palabr_guard: 'The game already have a word to guess.'
      }
      playinicial
    when '2'
      mensajes = {
        letras_utilizadas: 'Letras utilizadas:',
        introducir_letra: 'Introduzca una letra:',
        letra_repetida: 'Esta letra ya ha sido utilizada.',
        ganador: '¡Tenemos un ganador!',
        adivinaste_letra: '¡Adivinaste una letra correctamente!',
        pierde_vida: 'El usuario pierde una vida.',
        gmee_ovr: 'Game over! Te has quedado sin vidas!!',
        mensaje_inicial: 'ADIVINAR = A, CARGAR PARTIDA = C, SALIR = S:',
        empieza_juego: 'Empieza el juego, tú adivinas!',
        no_partida: 'No se encontró ninguna partida guardada.',
        load_game: '.....Cargando partida',
        closing_game: 'Cerrando juego.',
        entr_invalida: 'Entrada inválida. Por favor, pulsa A, C o S.',
        guard_salir: 'GUARDAR Y SALIR? (y/n)',
        guard_part: '.....Guardando partida',
        entr_anvalid: 'Letra erronea, introduzca (Y)es o (N)o',
        palabr_guard: 'La máquina ya tiene una palabra guardada.'
      }
      playinicial
    else
      puts 'Please write 1 or 2'
    end
  end

  def playinicial
    loop do
      puts mensajes[:mensaje_inicial]
      answer = gets.chomp.downcase

      case answer
      when 'a'
        vidas = 6
        puts '----------------------'
        puts '|      hangman       |'
        puts '----------------------'
        puts mensajes[:empieza_juego]
        @breaker.partida
      when 'c'
        puts '.'
        puts '..'
        puts '...'
        puts '....'
        puts mensajes[:load_game]
        load_game
      when 's'
        puts mensajes[:closing_game]
        exit
      else
        puts mensajes[:entr_invalida]
      end
    end
  end

  def save_game
    game_data = {
      guess: @guess,
      solucion: @solucion,
      vidas: @vidas,
      used_letters: @used_letters,
      mensajes: @mensajes
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
      @mensajes = game_data['mensajes']
      @breaker.partida
    else
      puts mensajes[:no_partida]
    end
  end
end

new_game = Hangman.new
new_game.lang_inicial
