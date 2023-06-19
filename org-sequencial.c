#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef struct {
    int largura;
    int altura;
    int** dados;
} imagem;

imagem* le_img(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        printf("Erro ao abrir o arquivo.\n");
        return NULL;
    }

    char magicNumber[3];
    fscanf(file, "%2s", magicNumber);
    if (strcmp(magicNumber, "P1") != 0) {
        printf("Formato de arquivo PBM inválido.\n");
        fclose(file);
        return NULL;
    }

    int largura, altura;
    fscanf(file, "%d %d", &largura, &altura);

    // Aloca memória para a estrutura img
    imagem* img = malloc(sizeof(img));
    img->largura = largura;
    img->altura = altura;
    img->dados = (int**)malloc(altura * sizeof(int*));

    // Lê os dados da imagem
    for (int i = 0; i < altura; i++) 
    {
        img->dados[i] = (int*)malloc(largura * sizeof(int));
        for (int j = 0; j < largura; j++) 
        {
            fscanf(file, "%d", &img->dados[i][j]);
        }
    }

    fclose(file);
    return img;
}

imagem* alocaimg(int altura, int largura)
{
    imagem* img = malloc(sizeof(img));
    if(img == NULL)
        return NULL;
    img->largura = largura;
    img->altura = altura;
    img->dados = (int**)malloc(altura * sizeof(int*));
        // Lê os dados da imagem
        for (int i = 0; i < altura; i++) 
        {
            img->dados[i] = (int*)malloc(largura * sizeof(int));
            for (int j = 0; j < largura; j++) 
            {
                img->dados[i][j] = 0;
            }
        }
    return img;
}

void imprimeimagem(imagem* img) {
    printf("largura: %d\n", img->largura);
    printf("altura: %d\n", img->altura);

    printf("img data:\n");
    for (int i = 0; i < img->altura; i++) {
        for (int j = 0; j < img->largura; j++) {
            printf("%d ", img->dados[i][j]);
        }
        printf("\n");
    }
}

/*void lerMatrizArquivo(const char* nomeArquivo, int M[9][9]) {
    FILE* arquivo = fopen(nomeArquivo, "rb"); // Abrir o arquivo binário para leitura em modo binário

    if (arquivo == NULL) {
        printf("Erro ao abrir o arquivo.\n");
        return;
    }

    int linhas, colunas;

    fread(&linhas, sizeof(int), 1, arquivo); // Ler o número de linhas do arquivo
    fread(&colunas, sizeof(int), 1, arquivo); // Ler o número de colunas do arquivo

    for (int i = 0; i < linhas; i++) {
        for (int j = 0; j < colunas; j++) {
            fread(&M[i][j], sizeof(int), 1, arquivo); // Ler cada elemento da matriz do arquivo
        }
    }

    fclose(arquivo); // Fechar o arquivo
}*/

int main()
{
    int execucoes=0;
    while(execucoes<100)
    {

        double ti, tf, tempo;  //tempo inicial , tempo final
        ti = tf = tempo = 0;
        struct timeval tempo_inicio, tempo_fim;
        gettimeofday(&tempo_inicio,NULL);


        const char* filename = "imagem3.pbm";
        imagem* img = le_img(filename);
        if (img != NULL) 
            imprimeimagem(img);

        //CODIGO
        int x = img->altura, y = img->largura, i;

        //transformação 1

        imagem *T = alocaimg(img->altura, img->largura);
        if (img == NULL) 
        {
            printf("erro1");
            return 0;
        }

        
        for(x=0 ; x<img->altura ; x++)
        {
            for(y=0 ; y<img->largura ; y++)
            {
                if(img->dados[x][y] == 1)
                {
                    for(i=0; i<img->largura; i++)
                    {
                        if(img->dados[x][i] == 0)
                        {
                            int index = x * img->largura + i;
                            if(sqrt(pow(x - x, 2) + pow(y - i, 2)) < T->dados[x][i] || T->dados[x][i] == 0)
                            {
                                T->dados[x][i] = sqrt(pow(x - x, 2) + pow(y - i, 2));
                            }
                        }
                    }
                }
            }
        }

        printf("matriz T: \n"); 
        imprimeimagem(T);

        //transformação 2

        imagem *TDE = alocaimg(img->altura, img->largura);
        if (img == NULL) 
        {
            printf("erro2");
            return 0;
        }

        for(y=0 ; y<img->largura ; y++)        //anda na "horizontal"
        {
            for(x=0 ; x<img->altura ; x++)    //anda na "vertical"
            {
                double soma = 0;
                for(i=0; i<img->largura ; i++)
                {
                    if(T->dados[i][y] + sqrt(pow(i - x, 2)) < soma || soma == 0)
                    {
                        if((T->dados[i][y] == 0 && img->dados[i][y] == 1 )|| T->dados[i][y] != 0)
                        {
                            soma = T->dados[i][y] + sqrt(pow(i - x, 2));
                        }
                    }  
                }
                if(img->dados[x][y] == 1)    //faz com que os valores da imagem binaria '1' permaneçam = '0' por terem uma distancia nula deles mesmos
                    TDE->dados[x][y] = 0;
                else 
                    TDE->dados[x][y] = soma;
                //printf("soma de T[%d][%d] = %lf\n", x, y, TDE[x][y]);
            }
        }

        printf("matriz TDE: \n");
        imprimeimagem(TDE);

        gettimeofday(&tempo_fim,NULL);
        tf = (double)tempo_fim.tv_usec + ((double)tempo_fim.tv_sec * (1000000.0));
        ti = (double)tempo_inicio.tv_usec + ((double)tempo_inicio.tv_sec * (1000000.0));
        tempo = (tf - ti) / 1000;
        printf("\ntempo em milissegundos: %.3f\n", tempo);

        FILE* arquivo = fopen("sequencial3.txt", "a");
        if (arquivo == NULL) {
            printf("Erro ao abrir o arquivo.\n");
            return 1;
        }

        fprintf(arquivo, "\nexecução: %d tempo em milissegundos: %.3f", execucoes, tempo);
        fclose(arquivo);

        execucoes++; //incrementa o valor para sair do while 

    }
    return 0;
}