#Carga librerias----
library(tidyverse)
library(readxl)
#install.packages("skimr")
library (skimr)
# install.packages("janitor")
library(janitor)
# install.packages("tidyplots")
library(tidyplots)
# carga funciones----
contar_valores_unicos <- function(x){ #x es la columna a analizar mediante el siguiente formato:dataframe ["nombre_columna"]
  valores_unicos <- c((unique(x)))
  valores_unicos <- valores_unicos[[1]]
  return(length(valores_unicos))
}
detectar_outliers <- function(x) { #x es la columna a analizar mediante el siguiente formato dataframe [["nombre_columna"]]
  Q1 <- quantile(x, probs = 0.25)
  Q3 <- quantile(x, probs = 0.75)
  IQR <- Q3-Q1
  limite_inferior <- Q1 -(1.5 * IQR)
  limite_superior <- Q3 + (1.5 * IQR)
  return (x < limite_inferior | x > limite_superior)
}
#Importación de datos y limpieza de nombre de columnas----
datos_original <- read_excel("Base de datos MOUNTOLIVE1_UJA.xls", 
                             col_types = c("text", "text", "text", 
                                           "text", "text", "text", "numeric", 
                                           "text", "text", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "text", "numeric", "text", "text", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "text", "numeric", 
                                           "text", "numeric", "numeric", "numeric", 
                                           "text", "numeric", "text", "text", 
                                           "numeric", "numeric", "text", "numeric", 
                                           "text", "text", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "text", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "text", "numeric", "text", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric"))
datos_original <- clean_names(datos_original)
datos_modificados <- datos_original
# Refinamiento y limpieza datos----
resumen_datos <-  skim(datos_original)
#Convierto las variables tipo caracter pero que son categóricas a tipo factor. Por otra lado, algunas variables numericas tienen
#"<" o">" que las hacen identificar como tipo caracter, las proceso también.

# Refinamiento y limpieza datos: Provincia y dop----

datos_modificados$provincia <- as.factor(datos_modificados$provincia)
datos_modificados$dop <- as.factor(datos_modificados$dop)

# Refinamiento y limpieza datos: cultivo_riego_secano----

datos_modificados$cultivo_riego_secano[is.na(datos_modificados$cultivo_riego_secano)] <- "No_data"

datos_modificados$cultivo_riego_secano <- as.factor(datos_modificados$cultivo_riego_secano)

# Refinamiento y limpieza datos: Altitud----
datos_modificados <- datos_modificados %>% 
  mutate(altitud = recode(altitud,"<600"= "500"),
         altitud = recode(altitud,"600-800"= "700"),
         altitud = recode(altitud,">800"= "900")
  )

datos_modificados$altitud <- as.numeric(datos_modificados$altitud)

datos_modificados <- datos_modificados %>% 
  mutate(altitud = case_when(
    altitud < 600 ~ 0,
    altitud >= 600 & altitud <= 800 ~ 1 ,
    altitud > 800 ~ 2,
  ))

datos_modificados$altitud <- as.factor(datos_modificados$altitud)

# Refinamiento y limpieza datos: ss_amirina----
unique(datos_modificados$ss_amirina)

datos_modificados <- datos_modificados %>% 
  mutate(ss_amirina = recode(ss_amirina,"<10"= "5"))

datos_modificados$ss_amirina <- as.numeric(datos_modificados$ss_amirina)      

datos_modificados <- datos_modificados %>% 
  mutate(ss_amirina = case_when(
    ss_amirina < 10 ~ 0,
    ss_amirina >= 10 & ss_amirina <= 15 ~ 1 ,
    ss_amirina > 15 ~ 2    
  ))

datos_modificados$ss_amirina <- as.factor(datos_modificados$ss_amirina)          

# Refinamiento y limpieza datos: a_amirina----
unique(datos_modificados$a_amirina)

datos_modificados <- datos_modificados %>% 
  mutate(a_amirina = case_when(
    a_amirina == "<10" ~ 0,
    a_amirina == "14" ~ 1
  ))
datos_modificados$a_amirina <- as.factor(datos_modificados$a_amirina)

# Refinamiento y limpieza datos: ciclobranol----
unique(datos_modificados$ciclobranol)

datos_modificados <- datos_modificados %>% 
  mutate(ciclobranol = case_when(
    ciclobranol == "<10" ~ 0,
    ciclobranol == "10" ~ 1
  ))
datos_modificados$ciclobranol <- as.factor(datos_modificados$ciclobranol)

# Refinamiento y limpieza datos: colesterol----
unique(datos_modificados$colesterol)

datos_modificados <- datos_modificados %>% 
  mutate(colesterol = recode(colesterol,"<,1"= "<0,10"))

datos_modificados <- datos_modificados %>% 
  mutate(colesterol = case_when(
    colesterol == "<0,10" ~ 0,
    colesterol == "0.10000000000000001" ~ 1,
    colesterol == "0.20000000000000001" ~ 2
  ))

datos_modificados$colesterol <- as.factor(datos_modificados$colesterol)

# Refinamiento y limpieza datos: campestanol----
unique(datos_modificados$campestanol)

datos_modificados <- datos_modificados %>% 
  mutate(campestanol = recode(campestanol,"<,0,1"= "<0,10"))

datos_modificados <- datos_modificados %>% 
  mutate(campestanol = case_when(
    campestanol == "<0,10" | campestanol == "<0,1" ~ 0,
    campestanol == "0.10000000000000001" ~ 1
  ))

datos_modificados$campestanol <- as.factor(datos_modificados$campestanol)

# Refinamiento y limpieza datos: d_5_23_estigmastadienol----
unique(datos_modificados$d_5_23_estigmastadienol)

datos_modificados <- datos_modificados %>% 
  mutate(d_5_23_estigmastadienol = case_when(
    d_5_23_estigmastadienol == "<0,10" | d_5_23_estigmastadienol == "<0,1" ~ 0,
    d_5_23_estigmastadienol == "1" ~ 1
  ))

datos_modificados$d_5_23_estigmastadienol<- as.factor(datos_modificados$d_5_23_estigmastadienol)

# Refinamiento y limpieza datos: delta_tocoferol----
unique(datos_modificados$delta_tocoferol)
datos_modificados$delta_tocoferol<- as.factor(datos_modificados$delta_tocoferol)

# Refinamiento y limpieza datos: delta_tocoferol----
unique(datos_modificados$acido_ursolico)

datos_modificados <- datos_modificados %>% 
  mutate(acido_ursolico = recode(acido_ursolico,"<1"= "0.5"))

datos_modificados$acido_ursolico<- as.numeric(datos_modificados$acido_ursolico)

datos_modificados <- datos_modificados %>% 
  mutate(acido_ursolico = case_when(
    acido_ursolico < 1 ~ 0,
    acido_ursolico >= 1 ~ 1
  ))
datos_modificados$acido_ursolico<- as.factor(datos_modificados$acido_ursolico)

#Eliminación columnas innecesarias----

datos_modificados<- datos_modificados %>% 
  select(-c(id,municipio,laurico_c12_0,miristico_c14_0,
            erucico_c22_1,trans_oleicos_c18_1t,tr_l_c18_2t_tr_ln_c18_3t,
            brasicasterol,d_7_campesterol,uvaol,na_registro))

resumen_datos <- skim(datos_modificados)

#Identificación outliers----
#Identificación outliers: Identifico las columnnas continuas con outliers y el numero de ellos----
detectar_outliers <- function(x) { #x es la columna a analizar mediante el siguiente formato dataframe [["nombre_columna"]]
  Q1 <- quantile(x, probs = 0.25)
  Q3 <- quantile(x, probs = 0.75)
  IQR <- Q3-Q1
  limite_inferior <- Q1 -(1.5 * IQR)
  limite_superior <- Q3 + (1.5 * IQR)
  return (x < limite_inferior | x > limite_superior)
}

outliers <-  NULL
columnas_numericas_con_outliers <- c ()
numero_outliers <- c()
for (columna in names(datos_modificados)){
  if (is.numeric (datos_modificados[[columna]]) == FALSE){ #No se tienen en cuenta las variables factor
    next
  } 
  if (contar_valores_unicos(datos_modificados[columna]) <= 10) { #No se tienen en cuenta las variables ordinales
    next
  }
  outliers <- sapply(datos_modificados[columna], detectar_outliers)
  if (TRUE %in% outliers == TRUE){
    columnas_numericas_con_outliers <- c(columnas_numericas_con_outliers, columna)
    numero_outliers <- c(numero_outliers, sum(outliers== TRUE))
  } 
}
#Identificación outliers: Eliminación de un error de codificación----
datos_modificados$p_hpeaeda_descarb <- ifelse(datos_modificados$p_hpeaeda_descarb > 5000, 14.11, datos_modificados$p_hpeaeda_descarb)

for (col in names(datos_modificados)){
  cat(col,(contar_valores_unicos(datos_modificados[col])),"\n")
}

contar_valores_unicos(datos_modificados["colesterol"])


#Identificación outliers: Identifico las filas que presentan outliers----

datos_con_outliers <- datos_modificados[,columnas_numericas_con_outliers]
boxplot_info <- boxplot(datos_con_outliers, plot = FALSE)
nombres_columnas <- colnames(datos_con_outliers)
outliers_df_con_fila <- data.frame()
tolerancia <- 1e-9 # Define una pequeña tolerancia para la comparación numérica
for (i in 1:length(boxplot_info$out)) {
  valor_outlier <- boxplot_info$out[i]
  indice_columna <- boxplot_info$group[i]
  nombre_columna <- as.character(nombres_columnas[indice_columna])
  
  
  # Encontrar las filas donde la columna tiene el valor del outlier
  filas_outlier <- which(abs(datos_modificados[[nombre_columna]] - valor_outlier) < tolerancia)
  
  # Crear un data frame temporal para este outlier
  temp_df <- data.frame(
    valor_outlier = valor_outlier,
    nombre_columna = nombre_columna,
    fila = if (length(filas_outlier) > 0) paste(filas_outlier, collapse = ", ") else NA
  )
  
  # Combinar con el data frame principal de outliers
  outliers_df_con_fila <- rbind(outliers_df_con_fila, temp_df)
}

#Visualización datos----

#Visualizo la distribución de  los datos en aquellas variables que presentan outliers.
#Para asegurarme que estos outliers no son realmente eso, sino que son diferencias por la altitud.
#Creo un dataframe nuevo con los datos agrupados por altitud

# Convertir a formato long
mi_df_long <- datos_modificados [,c("altitud",columnas_numericas_con_outliers)] %>%
  pivot_longer(cols = -altitud,
               names_to = "variable",
               values_to = "valor")

# Crear el strip plot con paneles separados y color
ggplot(mi_df_long, aes(x = variable, y = valor, color = altitud)) +
  geom_jitter(width = 0.2, height = 0) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Distribución de Puntos por Variable con Color por Grupo",
       x = "Variable",
       y = "Valor",
       color = "Altitud") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Primera conclusión----
#Las filas 5,6,7 y 13 tienen un alto número de outliers muy extremos y no estan asociados a la altura.
#Además 5,6 y 7 se recogieron en la misma localidad.

# Eliminación filas 5,6,7 y 13 con outliers----
#Decido hacer una base de datos sin estos filas para  ver si mejora la calidad de los datos
datos_sin_filas <- datos_modificados[-c(5,6,7,13),]

outliers <-  NULL
sin_filas_columnas_numericas_con_outliers <- c ()
sin_filas_numero_outliers <- c()
for (columna in names(datos_sin_filas)){
  if (is.numeric (datos_sin_filas[[columna]]) == FALSE){ #No se tienen en cuenta las variables factor
    next
  } 
  if (contar_valores_unicos(datos_sin_filas[columna]) <= 10) { #No se tienen en cuenta las variables ordinales
    next
  }
  outliers <- sapply(datos_sin_filas[columna], detectar_outliers)
  if (TRUE %in% outliers == TRUE){
    sin_filas_columnas_numericas_con_outliers <- c(sin_filas_columnas_numericas_con_outliers, columna)
    sin_filas_numero_outliers <- c(sin_filas_numero_outliers, sum(outliers== TRUE))
  } 
}



datos_sin_filas_con_outliers <- datos_sin_filas[,sin_filas_columnas_numericas_con_outliers]
boxplot_info <- boxplot(datos_sin_filas_con_outliers, plot = FALSE)
nombres_columnas <- colnames(datos_sin_filas_con_outliers)
sin_filas_outliers_df_con_fila <- data.frame()
tolerancia <- 1e-9 # Define una pequeña tolerancia para la comparación numérica
for (i in 1:length(boxplot_info$out)) {
  valor_outlier <- boxplot_info$out[i]
  indice_columna <- boxplot_info$group[i]
  nombre_columna <- as.character(nombres_columnas[indice_columna])
  
  
  # Encontrar las filas donde la columna tiene el valor del outlier
  filas_outlier <- which(abs(datos_sin_filas[[nombre_columna]] - valor_outlier) < tolerancia)
  
  # Crear un data frame temporal para este outlier
  temp_df <- data.frame(
    valor_outlier = valor_outlier,
    nombre_columna = nombre_columna,
    fila = if (length(filas_outlier) > 0) paste(filas_outlier, collapse = ", ") else NA
  )
  
  # Combinar con el data frame principal de outliers
  sin_filas_outliers_df_con_fila <- rbind(sin_filas_outliers_df_con_fila, temp_df)
}


# Convertir a formato long
mi_df_long_sin_filas <- datos_sin_filas [,c("altitud",sin_filas_columnas_numericas_con_outliers)] %>%
  pivot_longer(cols = -altitud,
               names_to = "variable",
               values_to = "valor")

# Crear el strip plot con paneles separados y color
ggplot(mi_df_long_sin_filas, aes(x = variable, y = valor, color = altitud)) +
  geom_jitter(width = 0.2, height = 0) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Distribución de Puntos por Variable con Color por Grupo",
       x = "Variable",
       y = "Valor",
       color = "Altitud") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Segunda conclusión----
#Eliminar estas filas reduce el numero de outliers y los que quedan son menos extremos, ya con esto
#podría empezar a hacer un analisis. Sin embargo, voy a realizar el logaritmo a estas variable para mejorar
#aún mas el resultado.

datos_limpios <- datos_sin_filas
datos_limpios_columnas_con_outliers <- sin_filas_columnas_numericas_con_outliers

#Transformación logaritmica y evaluación de su impacto----
datos_logt <- datos_sin_filas
t <- 1e-12
datos_logt <- datos_logt %>%
  mutate(across(all_of(sin_filas_columnas_numericas_con_outliers), ~log(. + t))) %>%
  rename_with(.fn = ~ paste0("logt_", .), .cols = all_of(sin_filas_columnas_numericas_con_outliers))

logt_columnas_numericas_con_outliers <- paste0("logt_", sin_filas_columnas_numericas_con_outliers)


outliers <-  NULL
logt_columnas_numericas_con_outliers <- c ()
logt_numero_outliers <- c()
for (columna in names(datos_logt)){
  if (is.numeric (datos_logt[[columna]]) == FALSE){ #No se tienen en cuenta las variables factor
    next
  } 
  if (contar_valores_unicos(datos_logt[columna]) <= 10) { #No se tienen en cuenta las variables ordinales
    next
  }
  outliers <- sapply(datos_logt[columna], detectar_outliers)
  if (TRUE %in% outliers == TRUE){
    logt_columnas_numericas_con_outliers <- c(logt_columnas_numericas_con_outliers, columna)
    logt_numero_outliers <- c(logt_numero_outliers, sum(outliers== TRUE))
  } 
}



datos_logt_con_outliers <- datos_logt[,logt_columnas_numericas_con_outliers]
boxplot_info <- boxplot(datos_logt_con_outliers, plot = FALSE)
nombres_columnas <- colnames(datos_logt_con_outliers)
logt_outliers_df_con_fila <- data.frame()
tolerancia <- 1e-9 # Define una pequeña tolerancia para la comparación numérica
for (i in 1:length(boxplot_info$out)) {
  valor_outlier <- boxplot_info$out[i]
  indice_columna <- boxplot_info$group[i]
  nombre_columna <- as.character(nombres_columnas[indice_columna])
  
  
  # Encontrar las filas donde la columna tiene el valor del outlier
  filas_outlier <- which(abs(datos_logt[[nombre_columna]] - valor_outlier) < tolerancia)
  
  # Crear un data frame temporal para este outlier
  temp_df <- data.frame(
    valor_outlier = valor_outlier,
    nombre_columna = nombre_columna,
    fila = if (length(filas_outlier) > 0) paste(filas_outlier, collapse = ", ") else NA
  )
  
  # Combinar con el data frame principal de outliers
  logt_outliers_df_con_fila <- rbind(logt_outliers_df_con_fila, temp_df)
}


# Convertir a formato long
mi_df_long_logt <- datos_logt [,c("altitud",logt_columnas_numericas_con_outliers)] %>%
  pivot_longer(cols = -altitud,
               names_to = "variable",
               values_to = "valor")

# Crear el strip plot con paneles separados y color
ggplot(mi_df_long_logt, aes(x = variable, y = valor, color = altitud)) +
  geom_jitter(width = 0.2, height = 0) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Distribución de Puntos por Variable con Color por Grupo",
       x = "Variable",
       y = "Valor",
       color = "Altitud") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#He encontrado unos valores muy extremos de -
# Decido eliminar esos outliers tan extremos. Para ello,sustituyo estos valores por el valor p5


# Calcular el percentil 5 para cada una de esas variables
percentiles_p5 <- datos_logt %>%
  summarise(across(all_of(c("logt_luteolina","logt_x34dhpeaeda","logt_p_hpeaeda_descarb_ox")), ~ quantile(., 0.05, na.rm = TRUE)))

# Realizar la sustitución
datos_logt <- datos_logt %>%
  mutate(across(all_of(c("logt_luteolina","logt_x34dhpeaeda","logt_p_hpeaeda_descarb_ox")),
                ~ ifelse(. < -10, percentiles_p5[[cur_column()]], .)))


datos_limpios_logt <- datos_logt
datos_limpios_logt_columnas_con_outliers <- logt_columnas_numericas_con_outliers

#Pruebas distribución normal: Datos_limpios----
datos_limpios_numericos <- datos_limpios %>% 
  select(where(is.numeric))

mi_df_long_datos_limpios <- datos_limpios_numericos %>%
  pivot_longer(cols = everything(), # Selecciona todas las columnas
               names_to = "variable", # Nombre para la nueva columna de nombres de variables
               values_to = "valor")   # Nombre para la nueva columna de valores
#Graficos QQ
ggplot(mi_df_long_datos_limpios, aes(sample = valor)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~ variable, scales = "free") + # Un panel por variable numérica
  labs(title = "QQ-plots Normales de Variables Numéricas",
       x = "Cuantiles Teóricos Normales",
       y = "Cuantiles de la Muestra") +
  theme_minimal()


#Pruebas distribución normal: Datos_logt----
datos_limpios_logt_numericos <- datos_limpios_logt %>% 
  select(where(is.numeric))

mi_df_long_datos_limpios_logt <- datos_limpios_logt_numericos %>%
  pivot_longer(cols = everything(), # Selecciona todas las columnas
               names_to = "variable", # Nombre para la nueva columna de nombres de variables
               values_to = "valor")   # Nombre para la nueva columna de valores
#Graficos QQ
ggplot(mi_df_long_datos_limpios_logt, aes(sample = valor)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~ variable, scales = "free") + # Un panel por variable numérica
  labs(title = "QQ-plots Normales de Variables Numéricas",
       x = "Cuantiles Teóricos Normales",
       y = "Cuantiles de la Muestra") +
  theme_minimal()

#Conclusión final----

#Tengo una base de datos con algunos outliers (datos_limpios) y otra en la que he realizado una
#transformación logaritmica de estas variables con outliers (datos_limpios_logt). Voy a guardar las dos bases de datos 
# y las analizaré por separado. Además, guardo tambien los graficos QQ-plot de ambas bases de datos para
#saber que variables siguen una distribución normal para las pruebas estadísticas. Tambien guardo los nombres
#de las variables que presentan outliers en ambas bases de datos para tenerlas en cuentas en los calculos de la
#media y otros parametros.
library(rio)

#Añado una columna ID para identificar mejor los datos

datos_limpios <- datos_limpios %>%
  mutate(ID = row_number())

datos_limpios_ <- datos_limpios %>%
  select(ID, everything())


datos_limpios_logt <- datos_limpios_logt %>%
  mutate(ID = row_number())

datos_limpios_logt <- datos_limpios_logt %>%
  select(ID, everything())

export(datos_limpios, "datos_limpios.xlsx")
export(datos_limpios_logt, "datos_limpios_logt.xlsx")

variables_con_outliers <- list(datos_limpios = datos_limpios_columnas_con_outliers,
                               datos_limpios_logt = datos_limpios_logt_columnas_con_outliers)

