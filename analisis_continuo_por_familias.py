import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import spearmanr
from sklearn.preprocessing import StandardScaler

# --- 1. CARGA DE DATOS ---
df = pd.read_csv('datos_limpios_2.csv', sep=';')
df_clean = df[df['cultivo_riego_secano'] != 'No_data'].copy()

# Definición de las familias (Copiado exacto de tu solicitud)
families = {
    "Ácidos Grasos": [
        'palmitico_c16_0', 'palmitoleico_c16_1', 'margarico_c17_0', 'margaroleico_c17_1',
        'estearico_c18_0', 'oleico_c18_1', 'linoleico_c18_2', 'linolenico_c18_3',
        'araquidico_c20_0', 'eicosenoico_c20_1', 'behenico_c22_0', 'lignocerico_c24_0'
    ],
    "Esteroles": [
        'contenido_total_de_esteroles', 'colesterol', 'x24_metilencolesterol',
        'campesterol', 'campestanol', 'estigmasterol', 'd_5_23_estigmastadienol',
        'clerosterol', 'b_sitosterol_individual', 'sitostanol', 'd_5_avenasterol',
        'd_5_24_estigmastadienol', 'd_7_estigmastenol', 'd_7_avenasterol', 'b_sitosterol_aparente'
    ],
    "Terpenos": [
        'euvaol', 'eritrodiol', 'escualeno', 'acido_oleanolico', 'acido_ursolico', 'acido_maslinico'
    ],
    "Tocoferoles": [
        'alfa_tocoferol', 'beta_tocoferol', 'gamma_tocoferol'
    ],
    "Compuestos fenólicos": [
        'hidroxitirosol', 'tirosol', 'x34dhpeaeda_descarb', 'x34dhpeaeda_descarb_ox', 
        'oleuropeina', 'x34dhpeaeda', 'tirosil_acetato', 'p_hpeaeda_descarb_ox', 
        'p_hpeaeda_descarb', 'pinoresinol', 'acido_cinamico', 'p_hpeaeda', 
        'x34dhpeaea_ox_107', 'x34dhpeaea', 'luteolina', 'x34dhpeaea_ox_110', 'p_hpeaea'
    ]
}

# Limpieza general de columnas numéricas
all_cols = []
for f in families.values():
    all_cols.extend(f)

# Convertir a numérico y rellenar nulos
for col in list(set(all_cols)) + ['altitud']:
    if col in df_clean.columns:
        df_clean[col] = pd.to_numeric(df_clean[col], errors='coerce')
df_clean = df_clean.dropna(subset=['altitud'])
df_clean[all_cols] = df_clean[all_cols].fillna(df_clean[all_cols].median())

# --- 2. FUNCIÓN DE ANÁLISIS POR FAMILIA ---
def analyze_family(family_name, var_list):
    # Crear figura con 2 subplots (Secano | Regadío)
    fig, axes = plt.subplots(1, 2, figsize=(5, 6), sharey=True)
    fig.suptitle(f'{family_name.upper()}', fontsize=18, fontweight='bold', y=0.99)

    regimes = [('S', 'Secano', axes[0]), ('R', 'Regadío', axes[1])]

    for code, label, ax in regimes:
        sub_df = df_clean[df_clean['cultivo_riego_secano'] == code]
        
        # Filtrar variables válidas en esta submuestra
        significant_vars = []
        directions = []
        
        # Comprobar qué variables de la familia tienen correlación real con la altura
        valid_cols = [c for c in var_list if c in sub_df.columns]
        
        for col in valid_cols:
            if sub_df[col].std() == 0: continue
            rho, p_val = spearmanr(sub_df['altitud'], sub_df[col])
            
            # Filtro ligeramente más suave para familias pequeñas (p<0.15) 
            # para asegurar que vemos tendencias aunque sean sutiles
            threshold_p = 0.15 
            if p_val < threshold_p and abs(rho) > 0.3:
                significant_vars.append(col)
                directions.append(np.sign(rho))
        
        if not significant_vars:
            ax.text(0.5, 0.5, "Sin tendencia significativa\n(Metabolismo estable)", 
                    ha='center', va='center', transform=ax.transAxes, fontsize=12, color='gray')
            ax.set_title(label, fontsize=14)
            ax.set_xlabel('Altitud (m)')
            ax.grid(False)
            sns.despine(ax=ax)
            continue

        # Cálculo del Índice de Familia
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(sub_df[significant_vars])
        X_adjusted = X_scaled * np.array(directions)
        composite_index = np.mean(X_adjusted, axis=1)
        
        plot_data = pd.DataFrame({
            'Altitud': sub_df['altitud'],
            'Indice': composite_index
        }).sort_values(by='Altitud')

        # Graficar
        sns.scatterplot(data=plot_data, x='Altitud', y='Indice', s=150, color='blue', 
                        edgecolor='white', linewidth=1.5, ax=ax, zorder=10)
        
        sns.regplot(data=plot_data, x='Altitud', y='Indice', scatter=False, order=2, 
                    color='gray', line_kws={'alpha':0.5, 'linestyle':'--'}, ax=ax)

        # Estética
        ax.set_title(f"{label}", fontsize=14)
        ax.set_xlabel('Altitud (m)', fontsize=12, fontweight='bold')
        if ax == axes[0]:
            ax.set_ylabel('Índice altitud (Z-Score)', fontsize=12)
        else:
            ax.set_ylabel('') # Quitar etiqueta Y en el segundo gráfico para limpieza
            
        ax.set_ylim(-2.5, 2.5) # Escala fija para comparación
        ax.grid(False)
        ax.axhline(0, color='black', linewidth=0.5, linestyle='-', alpha=0.3)
        sns.despine(ax=ax)

    plt.tight_layout()
    plt.show()

# --- 3. EJECUCIÓN ---
print("Generando análisis por familias...")
for name, vars_list in families.items():
    analyze_family(name, vars_list)
