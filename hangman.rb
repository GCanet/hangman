class Hangman
  attr_accessor :resultado, :guess, :solucion

  def initialize
    @breaker = Breaker.new(self)
    @resultado = ''
    @guess = ''
    @solucion = ''
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
  attr_accessor

  def initialize(hangman)
    @hangman = hangman
  end

  def partida
    palabra_maquina
    user_guess
  end

  def palabra_maquina
    fname = 'dictionary.txt'

    File.readlines(fname).each do |word|
      ### falta randomizar
      if word.length > 5 && word.length < 12
        @hangman.solucion = word
      end
    end
    puts "La máquina ya tiene palabra, su longitud es: #{@hangman.solucion.length}."
  end

  def user_guess
    puts 'Introduzca su palabra:'
    @hangman.guess = gets.chomp.upcase.split('')
  end
end

new_game = Hangman.new
new_game.playinicial
