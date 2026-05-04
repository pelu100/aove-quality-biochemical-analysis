#Carga librerias necesarias ----
# install.packages("tidyverse")
library(tidyverse)
library(readxl)
# install.packages("skimr")
library (skimr)
# install.packages("janitor")
library(janitor)
# install.packages("tidyplots")
library(tidyplots)
# install.packages("car")
library(car)
library(ggplot2)
# install.packages("FSA")
library(FSA)
# install.packages("ARTool")
library(ARTool)

#Carga archivo----

datos_limpios <- read_excel("datos_limpios.xlsx", 
                            sheet = "Sheet1", col_types = c("numeric", 
                                                            "text", "text", "text", "text", "numeric", 
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
                                                            "text", "numeric", "numeric", "numeric", 
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
                                                            "numeric"))
View(datos_limpios)
colnames(datos_limpios)


#Seleccion compuestos de interes: Acidos grasos

acidos_grasos <- datos_limpios %>% 
  select(ID, provincia,cultivo_riego_secano,altitud,palmitico_c16_0,palmitoleico_c16_1,margarico_c17_0,margaroleico_c17_1,
         estearico_c18_0,oleico_c18_1,linoleico_c18_2,linolenico_c18_3,araquidico_c20_0,eicosenoico_c20_1,behenico_c22_0,
         lignocerico_c24_0,saturados,insaturados,monoinsaturados,poliinsaturados,mono_poli)

acidos_grasos_filtrado <-  acidos_grasos %>% #Elimino los "No_data" de cultivo_tipo_riego
  filter(cultivo_riego_secano != "No_data")

nombres_acidos_grasos <- c(colnames(acidos_grasos))
nombres_acidos_grasos <- nombres_acidos_grasos[c(5:21)]

acidos_grasos$altitud <- as.factor(acidos_grasos$altitud)
acidos_grasos_filtrado$cultivo_riego_secano <- as.factor(acidos_grasos_filtrado$cultivo_riego_secano)
acidos_grasos_filtrado$altitud <- as.factor(acidos_grasos_filtrado$altitud)


#Agrupación por altitud----

#Creo un dataframe nuevo con estos datos agrupados por altitud para visualizarlos mejor
altitud_agrupados <- datos_limpios [,c("altitud",nombres_acidos_grasos) ] %>%
  pivot_longer(cols = -altitud, # Selecciona todas las columnas
               names_to = "variable", # Nombre para la nueva columna de nombres de variables
               values_to = "valor")   # Nombre para la nueva columna de valores

#Visualización distribución de datos----

ggplot(altitud_agrupados, aes(x = variable, y = valor, color = altitud)) +
  geom_jitter(width = 0.2, height = 0) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Distribución de Puntos por Variable con Color por Grupo",
       x = "Variable",
       y = "Valor",
       color = "Altitud") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(altitud_agrupados, aes(x = altitud, y = valor)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = "free_y") + # Un boxplot por categoría de altitud para cada variable
  labs(title = "Boxplots de Variables por Altitud",
       x = "Altitud",
       y = "Valor") +
  theme_minimal()


#Comprobación de otras variables: cultivo_riego_secano----

cultivo_riego_secano_agrupados <- acidos_grasos [, c("altitud","cultivo_riego_secano",nombres_acidos_grasos) ] %>%
  pivot_longer(cols = -c(cultivo_riego_secano,altitud), # Selecciona todas las columnas
               names_to = "variable", # Nombre para la nueva columna de nombres de variables
               values_to = "valor")   # Nombre para la nueva columna de valores


ggplot(cultivo_riego_secano_agrupados, aes(x = altitud, y = valor, color = cultivo_riego_secano)) +
  geom_jitter(width = 0.2, alpha = 0.7) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Strip Plots de Variables por altitud, diferenciado por cultivo_riego_secano",
       x = "altitud",
       y = "Valor",
       color = "cultivo_riego_secano") +
  theme_minimal()

ggplot(cultivo_riego_secano_agrupados, aes(x = interaction(cultivo_riego_secano,altitud ), y = valor)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Boxplots de Variables por Combinación de altitud y cultivo_riego_secano",
       x = "Combinación de altitud y cultivo_riego_secano",
       y = "Valor") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Aunque no sea una gran diferencia, en algunos compuestos si se ve una posible influencia del tipo de cultivo.



#Pruebas normalidad----
#Para saber los analisis estadísticos a realziar, se van a realizar tanto una prueba de distribución normal como de homogeneidad de varianzas.
#Al final tendré un vector con los nombres de las variables con distribución normal, otro con distribución no-normal
# y aquellas con distribución normal y varianzas iguales y otras con distribución normal pero varianzas desiguales

#Graficos QQ plot normalidad datos

ggplot(altitud_agrupados, aes(sample = valor)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~ variable, scales = "free") + # Un panel por variable numérica
  labs(title = "QQ-plots Normales de Variables Numéricas",
       x = "Cuantiles Teóricos Normales",
       y = "Cuantiles de la Muestra") +
  theme_minimal()

#Test shapiro 
variables_normal <- c()
variables_no_normal <- c()
alpha <- 0.2 # Nivel de significancia

for (col_name in names(acidos_grasos)) {
  if (is.numeric(acidos_grasos[[col_name]]) && length(acidos_grasos[[col_name]]) >= 3 && length(acidos_grasos[[col_name]]) <= 5000) {
    shapiro_test <- shapiro.test(acidos_grasos[[col_name]])
    cat(paste("Prueba de Shapiro-Wilk para la variable:", col_name, "\n"))
    cat(paste("  Estadístico W:", round(shapiro_test$statistic, 3),
              ", p-valor:", round(shapiro_test$p.value, 3), "\n"))
    
    if (shapiro_test$p.value > alpha) {
      variables_normal <- c(variables_normal, col_name)
      cat("  -> Se considera que sigue una distribución normal (p >", alpha, ")\n\n")
    } else {
      variables_no_normal <- c(variables_no_normal, col_name)
      cat("  -> Se considera que NO sigue una distribución normal (p <= ", alpha, ")\n\n")
    }
  } else if (is.numeric(acidos_grasos[[col_name]])) {
    cat(paste("Prueba de Shapiro-Wilk para la variable:", col_name, "\n"))
    cat("  Tamaño de muestra fuera del rango recomendado (3-5000). No se puede realizar la prueba.\n\n")
  }
}

#Pruebas homogeneidad varianza----
library(car) # Necesitas instalar este paquete si no lo tienes

nombres_acidos_grasos<- c()
variables_normal_varianzas_no_iguales <- c()
alfa_levene <- 0.05

for (var_num in variables_normal) {
  cat(paste("Test de Levene para la variable:", var_num, "por grupo en", "altitud", "\n"))
  formula_levene <- formula(paste(var_num, "~", "altitud"))
  levene_result <- leveneTest(formula_levene, data = acidos_grasos)
  print(levene_result)
  
  p_valor_levene <- levene_result$`Pr(>F)`[1] # Extraer el p-valor
  
  if (p_valor_levene > alfa_levene) {
    nombres_acidos_grasos<- c(variables_normal_varianzas_iguales, var_num)
    cat(paste(" -> Las varianzas de", var_num, "se consideran iguales entre los grupos (p >", alfa_levene, ")\n\n"))
  } else {
    variables_normal_varianzas_no_iguales <- c(variables_normal_varianzas_no_iguales, var_num)
    cat(paste(" -> Las varianzas de", var_num, "se consideran diferentes entre los grupos (p <= ", alfa_levene, ")\n\n"))
  }
}

#Analisis estadistico variables distribución normal: ANOVA de un solo factor (altitud)----

for (dep_var in variables_normal) {
  cat(paste("ANOVA de un factor para la variable dependiente:", dep_var, "\n"))
  
  # Crear la fórmula dinámicamente
  formula_anova <- formula(paste(dep_var, "~ altitud"))
  
  # Realizar el ANOVA
  modelo_anova <- aov(formula_anova, data = acidos_grasos)
  
  # Mostrar el resumen
  print(summary(modelo_anova))
  cat("\n")
  # Opcional: Verificar los supuestos para cada variable dependiente CON TÍTULO
  # par(mfrow = c(2, 2)) # Para mostrar 4 gráficos en una ventana
  # 
  # plot(modelo_anova, 1, main = paste("Residuos vs. Ajustados -", dep_var))
  # plot(modelo_anova, 2, main = paste("QQ-Plot Normal de Residuos -", dep_var))
  # hist(residuals(modelo_anova), main = paste("Histograma de Residuos -", dep_var), xlab = "Residuos")
  # boxplot(residuals(modelo_anova) ~ acidos_grasos$altitud :acidos_grasos$cultivo_riego_secano,
  #         main = paste("Boxplot de Residuos por Grupos -", dep_var),
  #         xlab = "Combinación de Factores", ylab = "Residuos")
  # 
  # par(mfrow = c(1, 1)) # Restablecer la configuración de la ventana gráfica
  
  # Opcional: Realizar pruebas post-hoc si los efectos son significativos
  if (summary(modelo_anova)[[1]]$`Pr(>F)`[1] < 0.05) { # Ejemplo para factor_a
    print(TukeyHSD(modelo_anova, "altitud"))
  }
  # if (summary(modelo_anova)[[1]]$`Pr(>F)`[2] < 0.05) { # Ejemplo para factor_b
  #   print(TukeyHSD(modelo_anova, "cultivo_riego_secano"))
  # }
}

# Solo he encontrado diferencias en las siguientes compuestos y altitudes:

# palmitoleico_c16_1: 2-0 (p = 0.0015758) y 2-1 (p = 0.0033613)


#Analisis estadistico variables distribución normal: ANOVA de dos factores (altitud y cultivo_riego_secano)----


for (dep_var in variables_normal) {
  cat(paste("ANOVA de dos factores para la variable dependiente:", dep_var, "\n"))
  
  # Crear la fórmula dinámicamente
  formula_anova <- formula(paste(dep_var, "~ altitud * cultivo_riego_secano"))
  
  # Realizar el ANOVA
  modelo_anova <- aov(formula_anova, data = acidos_grasos_filtrado )
  
  # Mostrar el resumen
  print(summary(modelo_anova))
  cat("\n")
  # Opcional: Verificar los supuestos para cada variable dependiente CON TÍTULO
  # par(mfrow = c(2, 2)) # Para mostrar 4 gráficos en una ventana
  # 
  # plot(modelo_anova, 1, main = paste("Residuos vs. Ajustados -", dep_var))
  # plot(modelo_anova, 2, main = paste("QQ-Plot Normal de Residuos -", dep_var))
  # hist(residuals(modelo_anova), main = paste("Histograma de Residuos -", dep_var), xlab = "Residuos")
  # boxplot(residuals(modelo_anova) ~ acidos_grasos$altitud :acidos_grasos$cultivo_riego_secano,
  #         main = paste("Boxplot de Residuos por Grupos -", dep_var),
  #         xlab = "Combinación de Factores", ylab = "Residuos")
  # 
  # par(mfrow = c(1, 1)) # Restablecer la configuración de la ventana gráfica
  
  # Opcional: Realizar pruebas post-hoc si los efectos son significativos
  if (summary(modelo_anova)[[1]]$`Pr(>F)`[1] < 0.05) { # Ejemplo para factor_a
    print(TukeyHSD(modelo_anova, "altitud"))
  }
  if (summary(modelo_anova)[[1]]$`Pr(>F)`[2] < 0.05) { # Ejemplo para factor_b
    print(TukeyHSD(modelo_anova, "cultivo_riego_secano"))
  }
}


# Solo he encontrado diferencias en las siguientes compuestos y altitudes:

# palmitoleico_c16_1: 2-0 (p = 0.0043609) y 2-1 (p = 0.0049655). No hay diferencias entre tipo de cultivo



#Analisis variables distribución no normal: Analisis de un factor (altitud)----

resultados_analisis <- list()

# Bucle para iterar sobre cada variable continua
for (variable_actual in variables_no_normal) {
  
  cat("--------------------------------------------------\n")
  cat("Analizando la variable:", variable_actual, "\n")
  cat("--------------------------------------------------\n")
  
  # Verificar si la variable continua actual existe en el dataframe
  if (!variable_actual %in% names(acidos_grasos)) {
    cat("Error: La variable", variable_actual, "no se encuentra en el dataframe.\n")
    next # Saltar a la siguiente variable en el bucle
  }
  
  # Realizar el test de Kruskal-Wallis para Altitud
  kruskal_altitud <- kruskal.test(acidos_grasos[[variable_actual]] ~ acidos_grasos$altitud, data = acidos_grasos)
  print(kruskal_altitud)
  
  # Realizar el post-hoc de Dunn si Kruskal-Wallis es significativo
  if (kruskal_altitud$p.value < 0.05) {
    cat("\nKruskal-Wallis significativo. Realizando post-hoc de Dunn...\n")
    # Es importante usar acidos_grasos = acidos_grasos dentro de dunnTest para que reconozca las columnas
    dunn_altitud <- dunnTest(acidos_grasos[[variable_actual]] ~ acidos_grasos$altitud, data = acidos_grasos, method = "bonferroni") # Puedes cambiar "bonferroni" por otro método de ajuste como "holm" o "fdr"
    print(dunn_altitud)
    # Almacenar resultados del caso 1
    resultados_analisis[[paste0(variable_actual, "_Caso1_Kruskal")]] <- kruskal_altitud
    resultados_analisis[[paste0(variable_actual, "_Caso1_Dunn")]] <- dunn_altitud
  } else {
    cat("\nKruskal-Wallis no significativo. No se realiza post-hoc de Dunn.\n")
    # Almacenar resultados del caso 1 (solo Kruskal)
    resultados_analisis[[paste0(variable_actual, "_Caso1_Kruskal")]] <- kruskal_altitud
  }
}

#Variables con significancia estadística: Análisis un factor
# oleico_c18_1: entre 1-2 (p = 0.02796713)
#linolenico_c18_3: 0-2 (p = 0.0136511)
#lignocerico_c24_0: 0-1 (p = 0.015033782) y 0-2 (p = 0.001626923)
# monoinsaturados: 1-2 (p = 0.04091317)



#Analisis variables distribución no normal: Analisis doble factor (altitud y cultivo_riego_secano)----
resultados_analisis_completo <- list()

# Umbral de significancia (p-value)
alpha <- 0.05

# Bucle para iterar sobre cada variable continua
for (variable_actual in variables_no_normal) {
  
  cat("--------------------------------------------------\n")
  cat("Analizando la variable:", variable_actual, "\n")
  cat("--------------------------------------------------\n")
  
  # Verificar si la variable continua actual existe en el dataframe
  if (!variable_actual %in% names(acidos_grasos_filtrado)) {
    cat("Error: La variable", variable_actual, "no se encuentra en el dataframe.\n")
    next # Saltar a la siguiente variable en el bucle
  }
  
  # --- Realizar ART ANOVA ---
  cat("\n--- Realizando ART ANOVA ---\n")
  
  formula_art <- as.formula(paste(variable_actual, "~ altitud * cultivo_riego_secano"))
  
  tryCatch({
    # Ajustar el modelo ART
    # El 'data = acidos_grasos_filtrado' es fundamental para que la fórmula funcione correctamente
    modelo_art <- art(formula_art, data = acidos_grasos_filtrado)
    
    # Obtener la tabla ANOVA del modelo ART
    tabla_anova <- anova(modelo_art)
    
    # Imprimir la tabla ANOVA
    print(tabla_anova)
    
    # Almacenar la tabla ANOVA
    resultados_analisis_completo[[paste0(variable_actual, "_ART_ANOVA")]] <- tabla_anova
    
    # --- Realizar Pruebas Post-Hoc si hay efectos significativos usando art.con() ---
    cat("\n--- Revisando significancia para Pruebas Post-hoc con art.con() ---\n")
    
    # Extraer p-valores de la tabla ANOVA
    # Usamos nombres de fila para ser más robustos a cambios en el orden de los factores
    p_altitud <- tabla_anova["altitud", "Pr(>F)"]
    p_cultivo <- tabla_anova["cultivo_riego_secano", "Pr(>F)"]
    # Para la interacción, el nombre exacto en la tabla ANOVA es "altitud:cultivo_riego_secano"
    p_interaccion <- tabla_anova["altitud:cultivo_riego_secano", "Pr(>F)"]
    
    
    # Revisa si la interacción es significativa primero
    if (!is.na(p_interaccion) && p_interaccion < alpha) {
      cat("Interacción Altitud * Cultivo significativa (p =", round(p_interaccion, 4), "). Realizando post-hoc en grupos combinados con art.con()...\n")
      
      # Post-hoc para la interacción usando art.con()
      # Especificamos el término de interacción como segundo argumento
      posthoc_interaccion <- art.con(modelo_art, "altitud:cultivo_riego_secano")
      print(posthoc_interaccion)
      resultados_analisis_completo[[paste0(variable_actual, "_PostHoc_Interaccion")]] <- posthoc_interaccion
      
    } else {
      cat("Interacción Altitud * Cultivo NO significativa (p =", round(p_interaccion, 4), ").\n")
      
      # Si la interacción no es significativa, revisamos los efectos principales
      if (!is.na(p_altitud) && p_altitud < alpha) {
        cat("Efecto principal de Altitud significativo (p =", round(p_altitud, 4), "). Realizando post-hoc para Altitud con art.con()...\n")
        # Post-hoc para el efecto principal de Altitud usando art.con()
        posthoc_altitud <- art.con(modelo_art, "altitud")
        print(posthoc_altitud)
        resultados_analisis_completo[[paste0(variable_actual, "_PostHoc_Altitud")]] <- posthoc_altitud
      } else {
        cat("Efecto principal de Altitud NO significativo (p =", round(p_altitud, 4), "). No se realiza post-hoc.\n")
      }
      
      if (!is.na(p_cultivo) && p_cultivo < alpha) {
        cat("Efecto principal de Cultivo_Riego_Secano significativo (p =", round(p_cultivo, 4), "). Realizando post-hoc para Cultivo_Riego_Secano con art.con()...\n")
        # Post-hoc para el efecto principal de Cultivo_Riego_Secano usando art.con()
        posthoc_cultivo <- art.con(modelo_art, "cultivo_riego_secano")
        print(posthoc_cultivo)
        resultados_analisis_completo[[paste0(variable_actual, "_PostHoc_Cultivo")]] <- posthoc_cultivo
      } else {
        cat("Efecto principal de Cultivo_Riego_Secano NO significativo (p =", round(p_cultivo, 4), "). No se realiza post-hoc.\n")
      }
    }
    
  }, error = function(e) {
    cat("Error al realizar ART ANOVA o Post-hoc para", variable_actual, ": ", e$message, "\n")
    resultados_analisis_completo[[paste0(variable_actual, "_Error")]] <- e$message
  })
  
  cat("\nAnálisis para", variable_actual, "completado.\n")
  cat("==================================================\n\n")
  
}



#Variables con significancia estadística: Análisis 2 factores
# Altitud:
#  palmitico_c16_0(Posible interacción entre tipo cultivo y altitud. repetir prueba pero sin altitud > 800m)
#  margarico_c17_0:Posible interacción entre tipo cultivo y altitud
#  oleico_c18_1: 1-2 ( p = 0.0436)
#  linolenico_c18_3: 0-2 (p = 0.0159) y 1-2 (p = 0.0422) Posible interacción entre tipo cultivo y altitud
#  behenico_c22_0: Interaccion entre tipo de cultivo y altitud
# lignocerico_c24_0: 0-1 (p = 0.0053) y 0-2 (p = 0.0007)


#Tablas con datos: agrupados por altitud----
# --- PASO 1: Cargar paquetes necesarios ---
library(dplyr)
library(tidyr)

# Suponiendo que primera_seleccion_filtrado ya existe.

# --- PASO 2: Calcular la Media y el SEM (corrigiendo la estructura de summarise y across) ---
# Reemplaza:
# - 6:27 si tus columnas de variables a resumir son diferentes.
# - 'altitud' por el nombre de tu variable de grupo si es diferente.

tabla_larga_metricas <- acidos_grasos%>%
  group_by(altitud) %>% # Agrupa por la variable de grupo
  summarise(
    # Usa across para aplicar los cálculos a múltiples columnas
    across(
      # Argumento .cols: Selecciona las columnas. colnames() es correcto aquí.
      nombres_acidos_grasos,

      # Argumento .fns: La lista de funciones a aplicar.
      list(mean = ~mean(., na.rm = TRUE),
           sem = ~sd(., na.rm = TRUE) / sqrt(n())),

      # Argumento .names: Cómo nombrar las columnas de salida.
      .names = "{.col}__{.fn}" # Nombra las columnas temporalmente con '__'
    ), # <--- **Cierre CORRECTO de la función across()**

    # Argumento .groups: De summarize(), va DESPUÉS de across()
    .groups = "drop" # Desagrupa al final del summarise
  ) %>% # <--- Cierre CORRECTO de la función summarise(), seguido de la tubería
  # --- PASA A FORMATO LARGO ---
  # Transforma de columnas anchas (var1__mean, var1__sem, etc.) a filas largas
  pivot_longer(cols = -altitud, # Selecciona todas las columnas EXCEPTO la altitud
               names_to = c("Variable", ".value"), # Divide el nombre (ej. 'var1__mean')
               names_sep = "__") # Usa '__' como el separador
# --- IMPRIMIR TABLA INTERMEDIA PARA DIAGNOSTICAR ---

# La tabla_larga_metricas ahora tiene columnas: altitud, Variable, mean, sem
# ... (el resto del código para pivotear y formatear la tabla final es el mismo) ...


# --- PASO 3: Combinar Media y SEM en una cadena de texto y Pivotear a formato Ancho Final ---
# Define cuántos decimales quieres en tu salida
# Define cuántos decimales quieres en tu salida
decimales <- 3 # Puedes ajustar este número

tabla_resumen_formato_final <- tabla_larga_metricas %>%
  mutate(
    # Combina Mean y SEM en una cadena de texto "Media ± SEM"
    # Redondea los números al número de decimales especificado
    Media_SEM_Formato = paste0(round(mean, decimales), " ± ", round(sem, decimales))
    # Si necesitas manejar casos donde SEM es NA/NaN:
    # Media_SEM_Formato = case_when(
    #   is.na(sem) | is.nan(sem) ~ paste0(round(mean, decimales)), # Si SEM es NA/NaN, solo muestra la media
    #   TRUE ~ paste0(round(mean, decimales), " ± ", round(sem, decimales)) # De lo contrario, muestra Media ± SEM
    # )
  ) %>%
  # --- PIVOTEA A FORMATO ANCHO FINAL (Corregido: Añadido id_cols) ---
  # Transforma de filas (una por Variable por Grupo) a columnas por Grupo
  pivot_wider(names_from = altitud, # Las nuevas columnas serán las categorías de altitud ('0', '1', '2')
              values_from = Media_SEM_Formato, # Los valores en las celdas serán la cadena "Media ± SEM"
              id_cols = Variable) # <--- **¡AÑADIDO!** Le dice a R que solo 'Variable' identifica las filas.

# --- Paso 4: Imprimir la tabla final ---
cat("\n--- Tabla Resumen Final (Variables en filas, Grupos en columnas, Media ± SEM) ---\n")
print(tabla_resumen_formato_final)

tabla_resumen_formato_final <- tabla_resumen_formato_final %>%
  mutate(Variable = c("Ácido palmítico (C16:0)", "Ácido palmitoleico (C16:1)",
                      "Ácido margárico (C17:0)", "Ácido margaroleico (C17:1)",
                      "Ácido esteárico (C18:0)","Ácido oleico (C18:1)",
                      "Ácido linoleico (C18:2)", "Ácido linolenico (C18:3)",
                      "Ácido araquídico (C20:0)", "Ácido eicosenoico (C20:1)",
                      "Ácido behénico (C22:0)", "Ácido lignocerico (C24:0)",
                      "Ácidos grasos saturados", "Ácidos grasos insaturados","Ácidos grasos monoinsaturados (MUFA)",
                      "Ácidos grasos poliinsaturados (PUFA)","MUFA/PUFA"))


#Creo la tabla final para exportar
# install.packages("flextable")
library(flextable)
tabla_exportar <- flextable(tabla_resumen_formato_final)

tabla_exportar

tabla_exportar <- tabla_exportar %>%
  autofit() %>%  #Ajustar anchos de columna
  set_header_labels( #Cambiar nombres de las columnas
    "Variable" = "Compuestos",
    "0" = "<600 m",
    "1" = "600-800 m",
    "2" = ">800 m") %>%
  add_header_row(#añado una cabecera extra
    top = TRUE,
    values = c ("","","Altitud",""))

save_as_docx("Tabla resumen altitud" =tabla_exportar, path = "Tabla resumen altitud acidos grasos.docx")



#Tablas con datos: agrupados por cultivo_riego_secano----
# --- PASO 1: Cargar paquetes necesarios ---
library(dplyr)
library(tidyr)

# Suponiendo que primera_seleccion_filtrado ya existe.

# --- PASO 2: Calcular la Media y el SEM (corrigiendo la estructura de summarise y across) ---
# Reemplaza:
# - 6:27 si tus columnas de variables a resumir son diferentes.
# - 'altitud' por el nombre de tu variable de grupo si es diferente.

tabla_larga_tipo_cultivo <- acidos_grasos_filtrado %>%
  group_by(cultivo_riego_secano) %>% # Agrupa por la variable de grupo
  summarise(
    # Usa across para aplicar los cálculos a múltiples columnas
    across(
      # Argumento .cols: Selecciona las columnas. colnames() es correcto aquí.
      nombres_acidos_grasos,
      
      # Argumento .fns: La lista de funciones a aplicar.
      list(mean = ~mean(., na.rm = TRUE),
           sem = ~sd(., na.rm = TRUE) / sqrt(n())),
      
      # Argumento .names: Cómo nombrar las columnas de salida.
      .names = "{.col}__{.fn}" # Nombra las columnas temporalmente con '__'
    ), # <--- **Cierre CORRECTO de la función across()**
    
    # Argumento .groups: De summarize(), va DESPUÉS de across()
    .groups = "drop" # Desagrupa al final del summarise
  ) %>% # <--- Cierre CORRECTO de la función summarise(), seguido de la tubería
  # --- PASA A FORMATO LARGO ---
  # Transforma de columnas anchas (var1__mean, var1__sem, etc.) a filas largas
  pivot_longer(cols = -cultivo_riego_secano, # Selecciona todas las columnas EXCEPTO la altitud
               names_to = c("Variable", ".value"), # Divide el nombre (ej. 'var1__mean')
               names_sep = "__") # Usa '__' como el separador
# --- IMPRIMIR TABLA INTERMEDIA PARA DIAGNOSTICAR ---

# La tabla_larga_tipo_cultivo ahora tiene columnas: altitud, Variable, mean, sem
# ... (el resto del código para pivotear y formatear la tabla final es el mismo) ...


# --- PASO 3: Combinar Media y SEM en una cadena de texto y Pivotear a formato Ancho Final ---
# Define cuántos decimales quieres en tu salida
# Define cuántos decimales quieres en tu salida
decimales <- 3 # Puedes ajustar este número

tabla_resumen_tipo_cultivo <- tabla_larga_tipo_cultivo %>%
  mutate(
    # Combina Mean y SEM en una cadena de texto "Media ± SEM"
    # Redondea los números al número de decimales especificado
    Media_SEM_Formato = paste0(round(mean, decimales), " ± ", round(sem, decimales))
    # Si necesitas manejar casos donde SEM es NA/NaN:
    # Media_SEM_Formato = case_when(
    #   is.na(sem) | is.nan(sem) ~ paste0(round(mean, decimales)), # Si SEM es NA/NaN, solo muestra la media
    #   TRUE ~ paste0(round(mean, decimales), " ± ", round(sem, decimales)) # De lo contrario, muestra Media ± SEM
    # )
  ) %>%
  # --- PIVOTEA A FORMATO ANCHO FINAL (Corregido: Añadido id_cols) ---
  # Transforma de filas (una por Variable por Grupo) a columnas por Grupo
  pivot_wider(names_from = cultivo_riego_secano, # Las nuevas columnas serán las categorías de altitud ('0', '1', '2')
              values_from = Media_SEM_Formato, # Los valores en las celdas serán la cadena "Media ± SEM"
              id_cols = Variable) # <--- **¡AÑADIDO!** Le dice a R que solo 'Variable' identifica las filas.

# --- Paso 4: Imprimir la tabla final ---
cat("\n--- Tabla Resumen Final (Variables en filas, Grupos en columnas, Media ± SEM) ---\n")
print(tabla_resumen_tipo_cultivo)

tabla_resumen_tipo_cultivo <- tabla_resumen_tipo_cultivo %>% 
  mutate(Variable = c("Ácido palmítico (C16:0)", "Ácido palmitoleico (C16:1)",
                      "Ácido margárico (C17:0)", "Ácido margaroleico (C17:1)",
                      "Ácido esteárico (C18:0)","Ácido oleico (C18:1)",
                      "Ácido linoleico (C18:2)", "Ácido linolenico (C18:3)",
                      "Ácido araquídico (C20:0)", "Ácido eicosenoico (C20:1)",
                      "Ácido behénico (C22:0)", "Ácido lignocerico (C24:0)",
                      "Ácidos grasos saturados", "Ácidos grasos insaturados","Ácidos grasos monoinsaturados (MUFA)",
                      "Ácidos grasos poliinsaturados (PUFA)","MUFA/PUFA"))

#Creo la tabla final para exportar
# install.packages("flextable")
library(flextable)
tabla_exportar_tipo_cultivo <- flextable(tabla_resumen_tipo_cultivo)

tabla_exportar_tipo_cultivo

tabla_exportar_tipo_cultivo <- tabla_exportar_tipo_cultivo %>% 
  autofit() %>%  #Ajustar anchos de columna
  set_header_labels( #Cambiar nombres de las columnas
    "Variable" = "Compuestos",
    "R" = "Regadío",
    "S" = "Secano") %>%
  add_header_row(#añado una cabecera extra
    top = TRUE,
    values = c ("","Tipo de cultivo","")) %>% 
  merge_at(i = 1, j = 2:3, part = "header")

save_as_docx("Tabla resumen tipo cultivo" = tabla_exportar_tipo_cultivo, path = "Tabla resumen tipo cultivo acidos grasos.docx")



#Bucle para hacer graficos de barras de varias variables al mismo tiempo----
for (columna in nombres_acidos_grasos){
  acidos_grasos %>%  
    tidyplot(x = altitud, y = !!sym(columna)) %>%   
    add_mean_bar(alpha = 0.6) %>%  
    add_sem_errorbar(linewidth = 0.01) %>% 
    # adjust_y_axis(limits = c(170, 310)) %>%
    rename_x_axis_labels (new_names = c("0" = "<600",
                                        "1" = "600-800",
                                        "2" = ">800")) %>%
    adjust_y_axis_title(title = columna,fontsize = 10,face = "bold") %>% 
    adjust_x_axis_title(title = "Altitud (m)",fontsize = 10,face = "bold") %>%
    add_test_asterisks(method = "tukey_hsd", bracket.nudge.y = 0.1, hide.ns = TRUE, hide_info = TRUE) %>% 
    print()
}

for (columna in nombres_acidos_grasos){
  acidos_grasos_filtrado %>%  #Eje X = cultivo_riego_secano
    tidyplot(x = cultivo_riego_secano, y = !!sym(columna), color = altitud) %>%
    adjust_legend_title(title = "Altitud (m)", face = "bold") %>%
    add_mean_bar(alpha = 0.6) %>%
    add_sem_errorbar(linewidth = 0.01) %>%
    # adjust_y_axis(limits = c(5, 19)) %>%
    rename_x_axis_labels (new_names = c("S" = "Secano",
                                        "R" = "Regadío")) %>%
    rename_color_labels (new_names = c("0" = "<600",
                                       "1" = "600-800",
                                       "2" = ">800")) %>%
    adjust_y_axis_title(title = columna,fontsize = 10,face = "bold") %>%
    adjust_x_axis_title(title = "Tipo de cultivo",fontsize = 10,face = "bold") %>%
    add_test_asterisks(bracket.nudge.y = 0.1, hide.ns = TRUE, hide_info = TRUE) %>% 
    print()
}

for (columna in nombres_acidos_grasos){
  acidos_grasos_filtrado %>%  #Eje X = altitud
    tidyplot(x = altitud, y = !!sym(columna), color = cultivo_riego_secano) %>%
    adjust_legend_title(title = "Tipo de cultivo", face = "bold") %>%
    add_mean_bar(alpha = 0.6) %>%
    add_sem_errorbar(linewidth = 0.01) %>%
    # adjust_y_axis(limits = c(5, 19)) %>%
    rename_x_axis_labels (new_names = c("0" = "<600",
                                        "1" = "600-800",
                                        "2" = ">800")) %>%
    rename_color_labels (new_names = c("S" = "Secano",
                                       "R" = "Regadío")) %>%
    adjust_y_axis_title(title = columna,fontsize = 10,face = "bold") %>%
    adjust_x_axis_title(title = "Altitud",fontsize = 10,face = "bold") %>%
    add_test_asterisks(bracket.nudge.y = 0.1, hide.ns = TRUE, hide_info = TRUE) %>% 
    print()
}