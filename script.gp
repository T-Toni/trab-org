#para gerar os graficos gráficos

set terminal pngcairo enhanced font 'Verdana,10'

# Gráfico 1 - Sequencial 1 vs. Paralelo 1
set output 'Comparação_imagem1.png'
set xlabel 'Execução'
set ylabel 'Tempo (ms)'
set title 'Gráfico 1'
set yrange [0:*]
plot 'sequencial1.txt' using (int(column(2))):(column(6)) with linespoints title 'Sequencial 1', \
     'paralelo1.txt' using (int(column(2))):(column(6)) with linespoints title 'Paralelo 1'

# Gráfico 2 - Sequencial 2 vs. Paralelo 2
set output 'Comparação_imagem2.png'
set title 'Gráfico 2'
set yrange [0:*]
plot 'sequencial2.txt' using (int(column(2))):(column(6)) with linespoints title 'Sequencial 2', \
     'paralelo2.txt' using (int(column(2))):(column(6)) with linespoints title 'Paralelo 2'

# Gráfico 3 - Sequencial 3 vs. Paralelo 3
set output 'Comparação_imagem3.png'
set title 'Gráfico 3'
set yrange [0:*]
plot 'sequencial3.txt' using (int(column(2))):(column(6)) with linespoints title 'Sequencial 3', \
     'paralelo3.txt' using (int(column(2))):(column(6)) with linespoints title 'Paralelo 3'


#para gerar a tabela das médias dos tempos de execução

# Lista de nomes de arquivos
arquivos = "sequencial1.txt paralelo1.txt sequencial2.txt paralelo2.txt sequencial3.txt paralelo3.txt"

# Abertura do arquivo de tabela
set terminal pngcairo
set output 'Comparação_tabela.png'

# Imprimir cabeçalho da tabela
print "Arquivo\tMédia Tempo"

# Variáveis para armazenar os dados da tabela
dados_tabela = ""

# Nomes dos arquivos
nomes_arquivos = "img1-sequencial img1-paralelo img2-sequencial img2-paralelo img3-sequencial img3-paralelo"

# Loop sobre os arquivos
do for [i = 1:words(arquivos)] {
    # Nome do arquivo atual
    arquivo = word(arquivos, i)
    
    # Nome do arquivo para exibição na tabela
    nome_arquivo = word(nomes_arquivos, i)
    
    # Variáveis de soma e contagem para cada arquivo
    soma = 0
    contagem = 0
    
    # Leitura do arquivo e cálculo da soma
    stats arquivo using 6 nooutput
    
    # Cálculo da média para o arquivo atual
    media = STATS_mean
    
    # Exibição da linha da tabela
    linha = sprintf("%s\t%.3f", nome_arquivo, media)
    print linha
    
    # Adicionar linha à tabela
    dados_tabela = dados_tabela . linha . "\n"
}

# Gravar tabela em um arquivo temporário
dados_temporarios = 'temp_tabela.txt'
set print dados_temporarios
print dados_tabela
set print

# Criação da tabela
set datafile separator "\t"
set style fill solid
set key off

# Definir estilo de preenchimento das colunas
set style fill solid

# Definir espaçamento entre as colunas
set boxwidth 0.5

# Rotacionar os rótulos das colunas
set xtics rotate by -45

# Definir rótulos dos eixos x e y
set ylabel "tempo médio de execução (ms)"
set xtics ("img1-sequencial" 0, "img1-paralelo" 1, "img2-sequencial" 2, "img2-paralelo" 3, "img3-sequencial" 4, "img3-paralelo" 5)

# Plotar a tabela
plot dados_temporarios using ($0+1):2:xticlabels(1) with boxes lc rgb 'blue' notitle

# Fechamento do arquivo de tabela
set output


#para gerar a tabela de "speedups"

# Definir o nome do arquivo
dados = "temp_tabela.txt"

# Leitura dos valores do arquivo
sequencial1 = real(system(sprintf("awk '{print $2}' %s | sed -n '1p'", dados)))
paralelo1 = real(system(sprintf("awk '{print $2}' %s | sed -n '2p'", dados)))
sequencial2 = real(system(sprintf("awk '{print $2}' %s | sed -n '3p'", dados)))
paralelo2 = real(system(sprintf("awk '{print $2}' %s | sed -n '4p'", dados)))
sequencial3 = real(system(sprintf("awk '{print $2}' %s | sed -n '5p'", dados)))
paralelo3 = real(system(sprintf("awk '{print $2}' %s | sed -n '6p'", dados)))

# Cálculo dos speedups
speedup1 = sequencial1 / paralelo1
speedup2 = sequencial2 / paralelo2
speedup3 = sequencial3 / paralelo3

# Criação da tabela
set terminal pngcairo
set output 'speedups.png'
set datafile separator "\t"

set style fill solid
set key off

# Definir espaçamento entre as colunas
set boxwidth 0.5

# Definir rótulos dos eixos x e y
set ylabel "Speedup"
set xtics rotate by -45
set xtics ("img1" 0, "img2" 1, "img3" 2)

# Criar um arquivo temporário com os dados da tabela de speedups
dados_temporarios = 'temp_speedups.txt'
set print dados_temporarios
print "img1\t", speedup1
print "img2\t", speedup2
print "img3\t", speedup3
set print

# Plotar o gráfico
plot dados_temporarios using 2 with boxes lc rgb "blue"