require_relative 'ui'


def salva_rank(nome, pontos_totais)
  conteudo = "#{nome}\n#{pontos_totais}"
  File.write("rank.txt", conteudo)
end

def escolhe_palavra_secreta
  avisa_escolhendo_palavra
  texto = File.read("dicionario.txt")
  todas_as_palavras = texto.split("\n")
  numero_escolhido = rand(todas_as_palavras.size)
  palavra_secreta = todas_as_palavras[numero_escolhido].downcase
  avisa_palavra_escolhida(palavra_secreta)
end

def escolhe_palavra_secreta_pouco_consumo_memoria
  avisa_escolhendo_palavra
  arquivo = File.new("dicionario_novo.txt")
  qtde_palavras = arquivo.gets.to_i
  numero_escolhido = rand(qtde_palavras)
  for linha in 1..(numero_escolhido-1)
    arquivo.gets
  end
  palavra_secreta = arquivo.gets.strip.downcase
  arquivo.close
  avisa_palavra_escolhida(palavra_secreta)
end

def palavra_mascarada(chutes, palavra_secreta)
  mascara = ""
  palavra_secreta.chars.each { |letra|
    if chutes.include? letra
      mascara << letra
    else
      mascara << "_"
    end
  }
  mascara
end
def pede_chute_valido(chutes,erros, mascara)
  cabecalho_de_tentativas(chutes, erros, mascara)
  loop do
    chute = pede_um_chute
    if chutes.include? chute
      avisa_chute_efetuado(chute)
    else
      return chute
    end
  end
end
def joga(nome)
  palavra_secreta = escolhe_palavra_secreta
  erros = 0
  chutes = []
  pontos_ate_agora = 0

  while erros < 5
    mascara = palavra_mascarada(chutes, palavra_secreta)
    chute = pede_chute_valido(chutes, erros, mascara)
    chutes << chute

    chutou_uma_letra = chute.size == 1
    if chutou_uma_letra
      total_encontrado = palavra_secreta.count(chute)
      if total_encontrado == 0
        avisa_letra_nao_encontrada
        erros += 1
      else
        avisa_letra_encontrada(total_encontrado)
      end
    else
      acertou = chute == palavra_secreta
      if acertou
        avisa_acertou_palavra
        pontos_ate_agora += 100
        break
      else
        avisa_errou_palavra
        pontos_ate_agora -= 30
        erros += 1
      end
    end
  end
  avisa_pontos(pontos_ate_agora)
  pontos_ate_agora
end

def jogo_da_forca
  nome = da_boas_vindas
  pontos_totais = 0

  loop do
    pontos_totais += joga(nome)
    avisa_pontos_totais(pontos_totais)
    salva_rank(nome, pontos_totais)
    if nao_quer_jogar?
      break
    end
  end
end