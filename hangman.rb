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
      puts 'Para adivinar palabras pulsa A, para salir pulsa S (a/s):'
      awnser = gets.chomp.downcase
      if awnser == 'a'
        puts 'Empieza el juego, tú adivinas!'
        @breaker.partida
      elsif awnser == 's'
        puts 'Cerrando juego.'
        exit
      end
    end
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
    puts @hangman.solucion
  end

  def user_guess
    puts 'Introduzca su conjetura:'
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
      puts 'El usuario ha perdido!'
      @hangman.playinicial
    end
  end
end

new_game = Hangman.new
new_game.playinicial
