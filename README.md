# 🌿 Valorización del AOVE de Alta Montaña — Universidad de Jaén

Este repositorio contiene el pipeline completo de análisis de datos desarrollado durante mi etapa como investigador postdoctoral en la **Universidad de Jaén (UJA)**, dentro del proyecto MOUNTOLIVE. El objetivo es demostrar empíricamente cómo la **altitud del olivar** y el **tipo de cultivo (secano/regadío)** afectan a la composición química del Aceite de Oliva Virgen Extra (AOVE).

El proyecto combina análisis estadístico riguroso en **R** con visualización avanzada en **Python**, cubriendo más de 100 compuestos químicos organizados en 7 familias.

> **⚠️ Nota de Confidencialidad:** Los datasets originales y gran parte de los resultados obtenidos han sido omitidos por acuerdos de propiedad intelectual al tratarse de investigación activa. El código se expone públicamente para demostrar la metodología y el razonamiento analítico.

---

## 📌 Contexto y Problema

Los olivares de montaña son un activo agronómico diferencial en zonas como Jaén, pero carecen de una base científica sólida que justifique su etiquetado premium frente a olivares de cotas inferiores. Este proyecto aborda esa brecha: **¿cambia realmente el perfil químico del AOVE con la altitud, y en qué medida influye el tipo de cultivo?**

Las muestras se clasificaron en tres categorías de altitud: **<600 m · 600-800 m · >800 m**

---

## 🤖 Metodología de Desarrollo: AI-Augmented Research

Este proyecto fue desarrollado bajo un enfoque de colaboración estratégica con Inteligencia Artificial:

- **Dirección científica (autor):** Diseño experimental, selección de tests estadísticos (ANOVA, ART-ANOVA, Kruskal-Wallis), definición de hipótesis, interpretación de resultados y toma de decisiones sobre limpieza de datos.
- **Aceleración con IA:** Generación de estructuras de bucles automatizados en R, optimización del código de visualización (`tidyplots`, `ggplot2`, `seaborn`) y estructuración de pipelines en Python.

---

## 🚀 Pipeline Técnico (End-to-End)

### 1. Limpieza e Ingesta (`Limpieza_datos_originales.R`)

A partir de una base de datos bruta con ~100 variables químicas y múltiples problemas de codificación (valores `<10`, `<0,1`, tipos mixtos):

- Conversión y normalización de tipos de datos.
- Detección de outliers mediante **Rango Intercuartílico (IQR)** con inspección visual posterior mediante strip plots por altitud.
- Eliminación justificada de 4 muestras con outliers extremos no asociados a la altitud (misma localidad de recogida).
- Corrección manual de un error de codificación detectado (`p_hpeaeda_descarb > 5000`).
- Evaluación de distribuciones mediante **QQ-Plots** y aplicación de transformación logarítmica como alternativa para variables sesgadas.
- Exportación de dos datasets: sin transformar (`datos_limpios.xlsx`) y log-transformado (`datos_limpios_logt.xlsx`).

### 2. Análisis Estadístico por Familias Químicas (R)

Ocho scripts automatizados, uno por familia. Cada script ejecuta el mismo pipeline sobre sus variables:

- **EDA visual:** jitter plots y boxplots por grupo de altitud y tipo de cultivo.
- **Test de normalidad:** Shapiro-Wilk automático para clasificar cada variable.
- **Homogeneidad de varianzas:** Test de Levene.
- **Análisis de un factor (altitud):**
  - Variables normales → **ANOVA** + post-hoc Tukey HSD.
  - Variables no normales → **Kruskal-Wallis** + post-hoc Dunn con corrección de Bonferroni.
- **Análisis de dos factores (altitud × tipo de cultivo):**
  - Variables normales → **ANOVA factorial** con término de interacción.
  - Variables no normales → **ART-ANOVA** (*Aligned Rank Transform*), extensión no paramétrica del ANOVA factorial que preserva la capacidad de detectar interacciones entre factores.
  - Post-hoc seleccionado automáticamente: si la interacción es significativa se analiza sobre grupos combinados con `art.con()`; si no, se evalúan los efectos principales por separado.
- **Tablas de resultados:** Media ± SEM por grupo, exportadas directamente a `.docx` con formato de publicación científica mediante `flextable`.

### 3. Índice Compuesto y Análisis Continuo (Python)

Dos scripts que complementan el análisis discreto por categorías con una visión del gradiente continuo de altitud:

- **`analisis_continuo_conjunto.py`:** Construye un **índice químico global** seleccionando variables con correlación de Spearman significativa con la altitud (p<0.10, |ρ|>0.4), estandarizándolas (Z-score) y ponderándolas por la dirección de la correlación. El resultado se visualiza como scatter + regresión polinómica de 2º orden para secano y regadío por separado, con escala Y fija (±2) para comparabilidad directa.
- **`analisis_continuo_por_familias.py`:** El mismo procedimiento aplicado familia por familia para identificar cuáles responden al gradiente de altitud y cuáles permanecen estables.

---

## 📈 Principales Hallazgos

Como he comentado al principo de este README, por acuerdos de confidencialidad no puedo mostrar todos los resultados y conclusiones obtenidos. Lo único que puedo comentar es que cada familia química presenta un patrón de respuesta distinto a la altitud y el tipo de cultivo, lo que refuerza la necesidad de un análisis multidimensional.

---

## 🛠️ Stack Tecnológico

**R:** `tidyverse`, `readxl`, `ARTool`, `FSA`, `car`, `tidyplots`, `ggplot2`, `flextable`, `rio`, `janitor`

**Python:** `pandas`, `numpy`, `scipy`, `scikit-learn`, `seaborn`, `matplotlib`

**Estadística aplicada:** ANOVA, Kruskal-Wallis, ART-ANOVA factorial, post-hoc Tukey / Dunn-Bonferroni / contrast ART, correlación de Spearman, regresión polinómica.

---

## 📁 Estructura del Repositorio

```
├── Limpieza_datos_originales.R              # Limpieza, outliers y normalización
├── analisis_datos_acidos_grasos.R           # Análisis ácidos grasos
├── analisis_datos_compuestos_fenolicos.R    # Análisis compuestos fenólicos
├── analisis_datos_tocoferoles.R             # Análisis tocoferoles
├── analisis_datos_trigliceridos.R           # Análisis triglicéridos
├── analisis_datos_terpenos.R                # Análisis terpenos
├── analisis_datos_otros_lipidos.R           # Análisis esteroles
├── analisis_datos_beta_amirina_y_otros.R    # Análisis beta-amirina y otros
├── analisis_datos_CX_calidad_pigmentos.R    # Análisis calidad y pigmentos
├── analisis_continuo_conjunto.py            # Índice compuesto global (Python)
├── analisis_continuo_por_familias.py        # Índice por familia (Python)
└── README.md
```

> Los archivos de datos (`datos_limpios.xlsx`, `datos_limpios_2.csv`) no están incluidos por confidencialidad.

---

## ▶️ Cómo Ejecutar

**Requisitos R:**
```r
install.packages(c("tidyverse", "readxl", "ARTool", "FSA", "car",
                   "tidyplots", "ggplot2", "flextable", "rio", "janitor", "skimr"))
```

**Requisitos Python:**
```bash
pip install pandas numpy scipy scikit-learn seaborn matplotlib
```

**Orden de ejecución:**
1. `Limpieza_datos_originales.R` → genera `datos_limpios.xlsx`
2. Cualquier script `analisis_datos_*.R` de forma independiente (cada uno carga `datos_limpios.xlsx`)
3. Los scripts Python requieren `datos_limpios_2.csv` (versión CSV del dataset limpio)

---

## 🔍 Limitaciones y Trabajo Futuro

Este es un análisis en curso, no una publicación finalizada. Las principales áreas de mejora identificadas:

- **Corrección por comparaciones múltiples a nivel global:** Con más de 100 variables testadas, una corrección FDR (Benjamini-Hochberg) entre familias complementaría los análisis actuales.
- **Modularización del código R:** Los 8 scripts repiten la misma estructura; una función paramétrica única reduciría la duplicación.
- **Análisis comparativo con dataset log-transformado:** Los análisis actuales usan el dataset sin transformar. Una comparación sistemática de resultados con y sin transformación logarítmica añadiría robustez. No se realizó los análisis estadistico con el dataset log-transformado porque las variables generadas dificultarian la discusión posterior. Ej: no es lo mismo decir que los compuestos fenólicos se incrementan a partir de los 800 m que el log de la concentración de los compuestos fenólicos.
- **Análisis multivariante global:** Un PCA sobre todas las familias simultáneamente permitiría identificar perfiles completos de AOVE por altitud y tipo de cultivo. Sin embargo, debido a que el tamaño de muestra era bajo, se descartó este procedimiento.

---

## 🔗 Portfolio

Este proyecto forma parte de mi portfolio de Ciencia de Datos junto con:

**[🎾 Tennis Match Prediction](../tennis_prediction/)** — Pipeline completo de Machine Learning para predicción de partidos de tenis profesional (ATP y Challenger) con XGBoost, ingeniería de características temporales, calibración probabilística y análisis SHAP. Accuracy del 64% sobre datos de 2025.

---

**👤 Diego Herrera Ochoa**
*Data Scientist | PhD en Ciencias de la Salud | Investigador Postdoctoral UJA*
[LinkedIn](https://www.linkedin.com/in/diego-herrera-ochoa-314015377)

---
*Proyecto presentado como parte del portfolio del [Máster en Data Science e IA — Evolve Academy](https://evolve.es).*
