# 🌿 Modelado Analítico y Valorización del AOVE de Alta Montaña

Este repositorio contiene el pipeline integral de Ciencia de Datos desarrollado para la investigación sobre el Aceite de Oliva Virgen Extra (AOVE) de alta montaña en la Universidad de Jaén (UJA). El proyecto combina el rigor estadístico en **R** con el modelado avanzado en **Python**.

> **⚠️ Nota de Confidencialidad:** Debido a acuerdos de propiedad intelectual y tratarse de una investigación activa, los datasets originales y las gráficas con los resultados finales han sido omitidos. El código se expone públicamente para demostrar la metodología, el tratamiento de datos y la capacidad de validación de hipótesis de negocio.

## 📌 Contexto y Reto Analítico
El objetivo central es **demostrar empíricamente cómo la altitud afecta a la composición química del AOVE**, proporcionando una base científica para la revalorización comercial de los olivares de montaña.

Basándonos en estudios preliminares, se definieron tres categorías de altitud:
* **Baja:** < 600 m
* **Media:** 600 - 800 m
* **Alta:** > 800 m

El reto técnico consistió en validar si estas agrupaciones discretas capturan realmente los puntos de inflexión de la calidad química o si el comportamiento sigue un gradiente distinto.

## 🚀 Pipeline de Trabajo (End-to-End)

### 1. Ingesta y Limpieza Crítica (R)
Procesamiento de datos brutos de laboratorio mediante el script `Limpieza_datos_originales.R`:
* **Tratamiento de Outliers:** Implementación de funciones personalizadas basadas en el Rango Intercuartílico (IQR).
* **Análisis de Normalidad:** Evaluación mediante QQ-Plots y aplicación de transformaciones logarítmicas (`log-t`) para garantizar la validez de las pruebas paramétricas posteriores.

### 2. Automatización del Análisis por Familias (R)
Análisis de familias químicas (ácidos grasos, fenoles, terpenos, tocoferoles, etc.):
* **Control Multivariante:** Evaluación cruzada del impacto de la **Altitud** y el **Tipo de Cultivo** (Secano vs. Regadío).
* **Visualización de Alto Impacto:** Generación automatizada de gráficos con `ggplot2` y `tidyplots`, incluyendo Barras de Error Estándar (SEM) y marcado automático de significancia estadística (*p-values*).

### 3. Modelado Continuo y Validación de Umbrales (Python)
Para profundizar en la relación altitud-química, se utilizaron los scripts `analisis_continuo_por_familias.py` y `analisis_continuo_conjunto.py`:
* **Feature Engineering:** Creación de un "Índice de Familia" global. Se estandarizaron las variables (Z-Scores) mediante `StandardScaler` y se ponderaron según la dirección de su correlación de Spearman.
* **Threshold Discovery (Curve Fitting):** Ajuste de curvas polinómicas de segundo orden sobre la variable continua de altitud.
* **Validación de Categorías:** El análisis de las curvas permitió confirmar que los mayores cambios bioquímicos ocurren cerca de los umbrales definidos preliminarmente.

## 🛠️ Stack Tecnológico
* **R:** `tidyverse`, `car`, `ARTool`, `FSA`, `tidyplots`.
* **Python:** `pandas`, `scikit-learn`, `seaborn`, `scipy`.
* **Estadística:** ANOVA, correlación de Spearman, regresión polinómica, tests de significancia.

## 📈 Conclusiones e Impacto
Tras el análisis exhaustivo de los datos, se extraen las siguientes conclusiones clave con impacto directo en el sector:

1.  **Altitud y Perfil Saludable:** Se observa que la altitud afecta significativamente a la composición química, inclinando el producto hacia un **perfil más saludable** (optimización de la relación de ácidos grasos y aumento de compuestos fenólicos).
2.  **Influencia del Cultivo:** El tipo de cultivo (Secano vs. Regadío) actúa como un modulador crítico; la gestión hídrica altera la respuesta bioquímica del olivar ante la altitud.
3.  **Respuesta Diferencial:** Cada familia química presenta una sensibilidad única frente a la elevación; mientras algunos compuestos muestran una progresión lineal, otros presentan puntos de inflexión claros en altitudes medias.
4.  **Soporte a la Certificación:** El modelo proporciona una base científica sólida para el **etiquetado premium y la creación de Denominaciones de Origen Protegidas (DOP)** específicas para AOVE de montaña.
5.  **Optimización Agronómica:** Los resultados permiten a los productores predecir la calidad potencial de su cosecha según la ubicación geográfica, optimizando el momento de recolección para maximizar los atributos saludables.

---
**👤 Diego Herrera Ochoa**
*Data Scientist | PhD en Ciencias de la Salud | Analista de Datos Agronómicos*
[LinkedIn](https://www.linkedin.com/in/diego-herrera-ochoa-314015377)
