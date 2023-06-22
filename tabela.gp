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
