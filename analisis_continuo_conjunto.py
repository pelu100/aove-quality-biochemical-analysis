import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import spearmanr
from sklearn.preprocessing import StandardScaler

# --- CARGA DE DATOS ---
df = pd.read_csv('datos_limpios_2.csv', sep=';')
df_clean = df[df['cultivo_riego_secano'] != 'No_data'].copy()
chemical_cols = [col for col in df_clean.columns if col not in ['ID', 'provincia', 'dop', 'cultivo_riego_secano', 'altitud']]

# Conversión y limpieza
for col in chemical_cols + ['altitud']:
    df_clean[col] = pd.to_numeric(df_clean[col], errors='coerce')
df_clean = df_clean.dropna(subset=['altitud'])
df_clean[chemical_cols] = df_clean[chemical_cols].fillna(df_clean[chemical_cols].median())

def plot_publication_style(sub_df, title_text):
    if len(sub_df) < 3: return

    # 1. CÁLCULO DEL ÍNDICE (Mismo algoritmo robusto)
    significant_vars = []
    directions = []
    
    for col in chemical_cols:
        if sub_df[col].std() == 0: continue
        rho, p_val = spearmanr(sub_df['altitud'], sub_df[col])
        if p_val < 0.10 and abs(rho) > 0.4:
            significant_vars.append(col)
            directions.append(np.sign(rho))
    
    if not significant_vars:
        print(f"No hay suficientes variables significativas para {title_text}")
        return

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(sub_df[significant_vars])
    X_adjusted = X_scaled * np.array(directions)
    composite_index = np.mean(X_adjusted, axis=1)
    
    plot_data = pd.DataFrame({
        'Altitud': sub_df['altitud'],
        'Indice_Quimico': composite_index
    }).sort_values(by='Altitud')

    # 2. GRAFICAR (ESTILO LIMPIO)
    plt.figure(figsize=(5, 6)) # Tamaño compacto y profesional
    
    # Puntos (Scatter)
    sns.scatterplot(
        data=plot_data, 
        x='Altitud', 
        y='Indice_Quimico', 
        s=150,                # Puntos grandes
        color='blue',        # Color negro o gris oscuro es muy elegante en papers
        edgecolor='white',    # Borde blanco para separar
        linewidth=1.5,
        zorder=10
    )
    
    # Línea de tendencia
    sns.regplot(
        data=plot_data, 
        x='Altitud', 
        y='Indice_Quimico', 
        scatter=False, 
        order=2, 
        color='gray', 
        line_kws={'alpha':0.5, 'linestyle':'--', 'linewidth':2}
    )
    
    # TÍTULO SIMPLE
    plt.title(title_text, fontsize=18, fontweight='bold', pad=15)
    
    # EJES Y ESCALAS
    plt.xlabel('Altitud (m)', fontsize=12, fontweight='bold')
    plt.ylabel('Índice altitud (Z-Score)', fontsize=12)
    
    # FIJAR ESCALA Y (Requerimiento clave)
    plt.ylim(-2, 2)
    
    # ELIMINAR CUADRÍCULA (Requerimiento clave)
    plt.grid(False)
    
    # Línea base en 0 (opcional, ayuda visual sin ensuciar)
    plt.axhline(0, color='black', linewidth=0.5, linestyle='-', alpha=0.3)
    
    # Limpiar bordes superior y derecho (Estilo "Tufte" o minimalista)
    sns.despine() 

    plt.tight_layout()
    plt.show()

# Ejecutar con los títulos exactos que pediste
df_secano = df_clean[df_clean['cultivo_riego_secano'] == 'S']
df_regadio = df_clean[df_clean['cultivo_riego_secano'] == 'R']

plot_publication_style(df_secano, "Secano")
plot_publication_style(df_regadio, "Regadío")
