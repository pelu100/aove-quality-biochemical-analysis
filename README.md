# aove-quality-biochemical-analysis
Pipeline de análisis de datos para la valorización del AOVE de alta montaña. Implementación de limpieza avanzada (R), estadística multivariante y modelado de índices de calidad (Python).

# 🌿 Modelado Analítico y Valorización del AOVE de Alta Montaña

Este proyecto presenta un pipeline integral de Ciencia de Datos aplicado al sector AgriTech, centrado en el análisis bioquímico del Aceite de Oliva Virgen Extra (AOVE). 

> **⚠️ Nota de Confidencialidad:** Debido a acuerdos de propiedad intelectual de la Universidad de Jaén (UJA), los datasets originales no se incluyen en este repositorio. El código se expone para demostrar la capacidad técnica en R y Python, así como el rigor estadístico aplicado.

## 🚀 Flujo de Trabajo (End-to-End)

### 1. Ingesta y Limpieza Crítica (R)
Uso de `Limpieza_datos_originales.R` para transformar datos brutos de laboratorio en datos accionables:
* **Outlier Detection:** Implementación de funciones basadas en Rango Intercuartílico (IQR).
* **Normalización:** Evaluación de distribuciones mediante QQ-Plots y aplicación de transformaciones logarítmicas para asegurar la validez de los tests estadísticos.

### 2. Automatización del Análisis Estadístico (R)
Análisis pormenorizado de familias químicas (ácidos grasos, fenoles, terpenos, etc.):
* **Control de Variables:** Evaluación del impacto de la **Altitud** y el **Tipo de Cultivo (Secano vs. Regadío)**.
* **Visualización Científica:** Uso de `ggplot2` y `tidyplots` con integración de barras de error (SEM) y asteriscos de significancia estadística (`p-value`).

### 3. Feature Engineering e Índices Sintéticos (Python)
Cuando el análisis individual no es suficiente, se aplicaron técnicas avanzadas en Python para modelar la "Calidad Global":
* **Estandarización:** Uso de `StandardScaler` (Z-Scores) para unificar escalas de diferentes compuestos.
* **Algoritmo de Índice Químico:** Creación de una métrica compuesta basada en la dirección de la correlación de Spearman respecto a la altitud.
* **Modelado de Tendencias:** Ajuste de curvas polinómicas de segundo orden para visualizar el comportamiento del producto a distintas altitudes.

## 🛠️ Stack Tecnológico
* **R:** `tidyverse`, `car`, `ARTool`, `FSA`, `tidyplots`.
* **Python:** `pandas`, `scikit-learn`, `seaborn`, `scipy`.
* **Estadística:** ANOVA, correlación de Spearman, tests de normalidad, modelado polinómico.

## 📈 Resultados
El proyecto concluye con un informe ejecutivo (ver carpeta `/04_Reports`) que traduce la complejidad química en *insights* de negocio para la toma de decisiones agronómicas y estratégicas.

---
*👤 Diego Herrera Ochoa - Data Scientist | PhD en Ciencias de la Salud*
