programa
{
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> t
	inclua biblioteca Util --> u
	inclua biblioteca Sons --> sm

	const inteiro LARGURA_JANELA = 600
	const inteiro ALTURA_JANELA = 600
	const inteiro DELAY = 120
	const inteiro X_POSICOES_COMIDA[24] = {0,25,50,75,100,125,150,175,200,225,250,275,300,325,350,375,400,425,450,475,500,525,550,575}
	const inteiro Y_POSICOES_COMIDA[22] = {50,75,100,125,150,175,200,225,250,275,300,325,350,375,400,425,450,475,500,525,550,575}
	
	inteiro musica_jogo = -1
	inteiro som_comida = -1
	inteiro som_derrota = -1 
	
	funcao inicio()
	{
		logico rodando_jogo = verdadeiro
		inteiro pontuacao = 0
		logico direita=falso, esquerda=falso, cima=falso, baixo=falso
		inteiro x_cabeca_cobra = 275
		inteiro y_cabeca_cobra = 275
		logico bateu = falso
		inteiro x_comida = 300
		inteiro y_comida = 300
		inteiro x_posicoes_cauda_cobra[528]
		inteiro y_posicoes_cauda_cobra[528]
		inteiro tamanho_cobra = 2
		logico se_mordeu = falso
		
		criar_janela_game()
		carregar_sons()
		sm.reproduzir_som(musica_jogo, verdadeiro)
		enquanto(rodando_jogo == verdadeiro)
		{
			limpar_janela_game()
			desenhar_painel_pontuacao(pontuacao)
			direcionar_cobra(direita, esquerda, cima, baixo)
			atualiza_posicoes_cauda(x_posicoes_cauda_cobra, y_posicoes_cauda_cobra, x_cabeca_cobra, y_cabeca_cobra)
			mover_cobra(direita, esquerda, cima, baixo, x_cabeca_cobra, y_cabeca_cobra)
			atualizar_pontuacao(pontuacao, tamanho_cobra)
			bateu = verifica_bateu_parede(x_cabeca_cobra, y_cabeca_cobra)
			se_mordeu = verifica_se_mordeu(tamanho_cobra, x_posicoes_cauda_cobra, y_posicoes_cauda_cobra, x_cabeca_cobra, y_cabeca_cobra)
			se(bateu == verdadeiro ou se_mordeu == verdadeiro)
			{
				reiniciar(x_cabeca_cobra, y_cabeca_cobra, direita, esquerda, cima, baixo, tamanho_cobra)
			}
			desenhar_comida(x_comida, y_comida)
			desenhar_cabeca_cobra(x_cabeca_cobra, y_cabeca_cobra)
			desenhar_cauda_cobra(tamanho_cobra, x_posicoes_cauda_cobra, y_posicoes_cauda_cobra, x_cabeca_cobra, y_cabeca_cobra, x_comida, y_comida)
			sortear_pos_comida(x_cabeca_cobra, y_cabeca_cobra, x_comida, y_comida)
			g.renderizar()
			u.aguarde(DELAY)
		}
	}

	funcao criar_janela_game()
	{
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(LARGURA_JANELA, ALTURA_JANELA)
		g.definir_titulo_janela("Serpente")
	}

	funcao limpar_janela_game()
	{
		g.definir_cor(g.COR_BRANCO)
		g.limpar()
	}

	funcao desenhar_painel_pontuacao(inteiro pontuacao)
	{
		g.definir_cor(g.COR_AZUL)
		g.desenhar_retangulo(0, 0, LARGURA_JANELA, 50, falso, verdadeiro)
		g.definir_cor(g.COR_AMARELO)
		g.definir_tamanho_texto(25.0)
		g.desenhar_texto(10, 10, "Pontuação: " + pontuacao)
	}

	funcao desenhar_cabeca_cobra(inteiro x_cabeca_cobra, inteiro y_cabeca_cobra)
	{
		g.definir_cor(g.COR_PRETO)
		g.desenhar_retangulo(x_cabeca_cobra, y_cabeca_cobra, 25, 25,falso, verdadeiro)
	}

	funcao direcionar_cobra(logico &direita, logico &esquerda, logico &cima, logico &baixo)
	{
		se(t.tecla_pressionada(t.TECLA_SETA_DIREITA) == verdadeiro)
		{
			direita = verdadeiro 
			esquerda = falso 
			cima = falso 
			baixo = falso
		}
		senao se(t.tecla_pressionada(t.TECLA_SETA_ESQUERDA) == verdadeiro)
		{
			direita = falso 
			esquerda = verdadeiro 
			cima = falso 
			baixo = falso
		}
		senao se(t.tecla_pressionada(t.TECLA_SETA_ACIMA) == verdadeiro)
		{
			direita = falso 
			esquerda = falso 
			cima = verdadeiro 
			baixo = falso
		}
		senao se(t.tecla_pressionada(t.TECLA_SETA_ABAIXO) == verdadeiro)
		{
			direita = falso 
			esquerda = falso 
			cima = falso 
			baixo = verdadeiro
		}
	}

	funcao mover_cobra(logico direita, logico esquerda, logico cima, logico baixo, inteiro &x_cabeca_cobra, inteiro &y_cabeca_cobra)
	{
		se(direita == verdadeiro)
		{
			x_cabeca_cobra += 25
		}
		senao se(esquerda == verdadeiro)
		{
			x_cabeca_cobra -= 25
		}
		senao se(cima == verdadeiro)
		{
			y_cabeca_cobra -= 25
		}
		senao se(baixo == verdadeiro)
		{
			y_cabeca_cobra += 25
		}
	}

	funcao logico verifica_bateu_parede(inteiro x_cabeca_cobra, inteiro y_cabeca_cobra)
	{
		se(x_cabeca_cobra < 0 ou x_cabeca_cobra > LARGURA_JANELA - 25)
		{	
			sm.reproduzir_som(som_derrota, falso)
			retorne verdadeiro
		}
		senao se(y_cabeca_cobra < 50 ou y_cabeca_cobra > ALTURA_JANELA - 25)
			{
				sm.reproduzir_som(som_derrota, falso)
				retorne verdadeiro
			}
		senao
			{
				retorne falso
			}
	}

	funcao reiniciar(inteiro &x_cabeca_cobra, inteiro &y_cabeca_cobra, logico &direita, logico &esquerda, logico &cima, logico &baixo, inteiro &tamanho_cobra)
	{
		x_cabeca_cobra = 275
		y_cabeca_cobra = 275
		direita = falso 
		esquerda = falso 
		cima = falso 
		baixo = falso
		tamanho_cobra = 2
	}

	funcao logico verifica_comeu_comida(inteiro x_cabeca_cobra, inteiro y_cabeca_cobra, inteiro x_comida, inteiro y_comida)
	{
		se(x_cabeca_cobra == x_comida e y_cabeca_cobra == y_comida)
		{
			retorne verdadeiro
		}
		senao
		{
			retorne falso
		}
	}

	funcao sortear_pos_comida(inteiro x_cabeca_cobra, inteiro y_cabeca_cobra, inteiro &x_comida, inteiro &y_comida)
	{
		inteiro x_indice = u.sorteia(0,23)
		inteiro y_indice = u.sorteia(0,21)
		logico comeu = verifica_comeu_comida(x_cabeca_cobra, y_cabeca_cobra, x_comida, y_comida)
		se(comeu == verdadeiro)
		{
			sm.reproduzir_som(som_comida, falso)
			x_comida = X_POSICOES_COMIDA[x_indice]
			y_comida = Y_POSICOES_COMIDA[y_indice]
		}
	}

	funcao desenhar_comida(inteiro x_comida, inteiro y_comida)
	{
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_retangulo(x_comida, y_comida, 25, 25, verdadeiro, verdadeiro)
	}

	funcao atualiza_posicoes_cauda(inteiro x_posicoes_cauda_cobra[], inteiro y_posicoes_cauda_cobra[], inteiro x_cabeca_cobra, inteiro y_cabeca_cobra)
	{
		x_posicoes_cauda_cobra[0] = x_cabeca_cobra
		y_posicoes_cauda_cobra[0] = y_cabeca_cobra

		para(inteiro i = 527; i > 0; i--)
		{
			x_posicoes_cauda_cobra[i] = x_posicoes_cauda_cobra[i-1]
			y_posicoes_cauda_cobra[i] = y_posicoes_cauda_cobra[i-1]
		}
	}

	funcao desenhar_cauda_cobra(inteiro &tamanho_cobra, inteiro x_posicoes_cauda_cobra[], inteiro y_posicoes_cauda_cobra[], inteiro x_cabeca_cobra, inteiro y_cabeca_cobra, inteiro x_comida, inteiro y_comida)
	{
		logico comeu = verifica_comeu_comida(x_cabeca_cobra, y_cabeca_cobra, x_comida, y_comida)
		se(comeu == verdadeiro)
		{
			tamanho_cobra++
		}
		para(inteiro i = 0; i < tamanho_cobra; i++)
		{
			g.desenhar_retangulo(x_posicoes_cauda_cobra[i], y_posicoes_cauda_cobra[i], 25, 25, falso, verdadeiro)
		}
	}

	funcao atualizar_pontuacao(inteiro &pontuacao, inteiro tamanho_cobra)
	{
		pontuacao = tamanho_cobra - 2
		desenhar_painel_pontuacao(pontuacao)
	}

	funcao logico verifica_se_mordeu(inteiro tamanho_cobra, inteiro x_posicoes_cauda_cobra[], inteiro y_posicoes_cauda_cobra[], inteiro x_cabeca_cobra, inteiro y_cabeca_cobra)
	{
		logico se_mordeu = falso
		se(tamanho_cobra >= 3)
		{
			para(inteiro i = 0; i < tamanho_cobra; i++)
			{
				se(x_cabeca_cobra == x_posicoes_cauda_cobra[i] e y_cabeca_cobra == y_posicoes_cauda_cobra[i])
				{
					sm.reproduzir_som(som_derrota, falso)
					se_mordeu = verdadeiro
				}
			}
		}
		retorne se_mordeu
	}

	funcao carregar_sons()
	{
		sm.definir_volume(60)
		musica_jogo = sm.carregar_som("sons/musica_jogo.mp3")
		som_comida  = sm.carregar_som("sons/som_comida.mp3" )
		som_derrota = sm.carregar_som("sons/som_derrota.mp3")
	}
}

/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 5310; 
 * @DOBRAMENTO-CODIGO = [58, 65, 71, 80, 86, 118, 156, 192, 198, 210, 223];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */