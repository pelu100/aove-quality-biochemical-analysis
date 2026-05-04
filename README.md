# 🌿 Modelado Analítico y Valorización del AOVE de Alta Montaña

Este repositorio contiene el pipeline integral de Ciencia de Datos desarrollado para la investigación sobre el Aceite de Oliva Virgen Extra (AOVE) de alta montaña en la Universidad de Jaén (UJA). El proyecto combina el rigor estadístico en **R** con el modelado avanzado en **Python**.

> **⚠️ Nota de Confidencialidad:** Debido a acuerdos de propiedad intelectual y tratarse de una investigación activa, los datasets originales han sido omitidos. El código se expone públicamente para demostrar la metodología, el tratamiento de datos y la capacidad de validación de hipótesis.

## 📌 Contexto y Reto Analítico
El objetivo central es **demostrar empíricamente cómo la altitud afecta a la composición química del AOVE**, proporcionando una base científica para la revalorización comercial de los olivares de montaña.

Basándonos en estudios preliminares, se definieron tres categorías de altitud (<600m, 600-800m, >800m). El reto técnico consistió en validar si estas agrupaciones discretas capturan realmente los puntos de inflexión de la calidad química o si el comportamiento sigue un gradiente distinto.

## 🤖 Metodología de Desarrollo: AI-Augmented Analytics
Este proyecto fue desarrollado bajo un enfoque híbrido, combinando el conocimiento científico del dominio con el uso de **Inteligencia Artificial generativa** para la aceleración del código:
* **Dirección Científica y Analítica (Autor):** Diseño experimental, elección de los tests estadísticos adecuados (ANOVA, normalización logarítmica), definición de las familias químicas y formulación de la hipótesis matemática para el índice de calidad.
* **Aceleración con IA:** Uso de IA como "copiloto" de programación para generar estructuras de bucles en R, optimizar el código de visualización gráfica científica (`tidyplots`, `ggplot2`) y estructurar los pipelines de estandarización en Python. 
> *Este enfoque demuestra la capacidad para traducir rápidamente hipótesis biológicas complejas en pipelines de código funcionales y eficientes.*

## 🚀 Pipeline de Trabajo (End-to-End)

### 1. Ingesta y Limpieza Crítica (R)
Procesamiento de datos brutos mediante `Limpieza_datos_originales.R`:
* **Tratamiento de Outliers:** Funciones basadas en el Rango Intercuartílico (IQR).
* **Análisis de Normalidad:** Evaluación mediante QQ-Plots y aplicación de transformaciones logarítmicas (`log-t`) para garantizar la validez de las pruebas paramétricas.

### 2. Automatización del Análisis por Familias (R)
Análisis de compuestos químicos mediante scripts automatizados:
* **Control Multivariante:** Evaluación cruzada del impacto de la **Altitud** y el **Tipo de Cultivo** (Secano vs. Regadío).
* **Visualización de Alto Impacto:** Gráficos automatizados con Barras de Error Estándar (SEM) y marcado de significancia estadística (*p-values*).

### 3. Modelado Continuo y Validación de Umbrales (Python)
Scripts `python_2.py` y `python_3.py` para visualizar el gradiente real:
* **Feature Engineering:** Creación de un "Índice de Familia" global. Se estandarizaron las variables (Z-Scores) mediante `StandardScaler` y se ponderaron según su correlación de Spearman.
* **Threshold Discovery (Curve Fitting):** Ajuste de curvas polinómicas de 2º orden sobre la variable continua de altitud.
* **Validación de Categorías:** Confirmación visual y estadística de que los mayores cambios bioquímicos ocurren cerca de los umbrales agronómicos preliminares.

## 🛠️ Stack Tecnológico
* **R:** `tidyverse`, `car`, `ARTool`, `FSA`, `tidyplots`.
* **Python:** `pandas`, `scikit-learn`, `seaborn`, `scipy`.
* **Estadística:** ANOVA, correlación de Spearman, regresión polinómica, tests de significancia.

## 📈 Conclusiones e Impacto
Tras el análisis exhaustivo, se extraen conclusiones con impacto directo en el sector:
1.  **Altitud y Perfil Saludable:** La altitud inclina el producto hacia un perfil bioquímico de mayor valor saludable.
2.  **Influencia del Cultivo:** La gestión hídrica (Secano/Regadío) modula la respuesta química ante la altitud.
3.  **Respuesta Diferencial:** Cada familia química presenta puntos de inflexión únicos a medida que aumenta la elevación.
4.  **Soporte a la Certificación:** El modelo proporciona una base científica sólida para el etiquetado premium y la creación de Denominaciones de Origen Protegidas (DOP).
5.  **Optimización Agronómica:** Permite predecir la calidad potencial basándose en la ubicación geográfica.

---
**👤 Diego Herrera Ochoa**
*Data Scientist | PhD en Ciencias de la Salud | Analista de Datos Agronómicos*
[LinkedIn](https://www.linkedin.com/in/diego-herrera-ochoa-314015377)
