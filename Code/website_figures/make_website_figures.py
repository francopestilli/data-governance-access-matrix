#!/usr/bin/env python3
"""Website-style figures for the directional compatibility matrix.

Reproduces, as static publication figures, the four interactive views shown on
https://braindatagovernance.org/toolkit/legal-landscape/ :

  fig3a_matrix            directional compatibility matrix, ordered by region
  fig3b_network           enabled pathways (A1/A2/B) with jurisdictions on three regional rings
  fig3c_import_from_europe modal class of imports from the European reference set, on a map
  fig3d_import_entropy    Shannon entropy (bits) of each jurisdiction's incoming profile, on a map
  fig_corridors           class shares for every origin-region -> destination-region corridor

The numbers are the ones described in the manuscript Methods (diagonal treated as
missing; network thresholded to A1/A2/B with weights 3/2/1; node size = weighted
in-strength + out-strength; modal class over the 24-jurisdiction European reference
set, 23 for members of the set; entropy in bits over the six classes, zero-frequency
classes omitted, not normalised). Only the drawing differs from the manuscript's
Figure 3: the palette, the region ordering of the matrix, the fixed ring layout of
the network instead of a force-directed layout, and an equirectangular map window.

Usage
    python make_website_figures.py                      # default input and output paths
    python make_website_figures.py --input path/to/data-sharing-matrix.xlsx --outdir out

Input   ../jupyter_notebook_figures/input_file/data-sharing-matrix.xlsx (rows export, columns receive)
Output  PNG + PDF per figure, matrix.json (the file the website reads) and derived_measures.csv

Map boundaries: Natural Earth 50 m (downloaded on first run, as in the notebook). If the
download is not possible, place the npm package `world-atlas` file `countries-50m.json`
(Natural Earth 50 m, public domain) next to this script and it is used instead.

Requires: pandas, numpy, matplotlib, openpyxl, geopandas (with pyogrio), pycountry.
"""
import argparse, json, math, zipfile, urllib.request, sys
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Patch, Rectangle
from matplotlib.lines import Line2D
from matplotlib.colors import LinearSegmentedColormap

HERE = Path(__file__).resolve().parent

# --------------------------------------------------------------------------- style (as on the website)
CLASSES = ["A1", "A2", "B", "C", "D", "E"]
COL = {"A1": "#1b7f4a", "A2": "#8fcf8a", "B": "#f1c232", "C": "#e8842c", "D": "#c0392b", "E": "#6b7280"}
LABEL = {"A1": "A1 unified legal space", "A2": "A2 convergent architectures", "B": "B standard instruments",
         "C": "C operationally conditional", "D": "D restricted in practice", "E": "E insufficient certainty"}
REGION_COL = {"Europe": "#005981", "Africa": "#e57536", "Latin America & Caribbean": "#a9262c"}
REGIONS = ["Europe", "Africa", "Latin America & Caribbean"]
WEIGHT = {"A1": 3, "A2": 2, "B": 1}
FG, MUTED, LINE = "#1d2230", "#5a6273", "#c9cfd6"
MAP_BG, LAND, NOT_CODED = "#f4f7f9", "#d9dee3", "#555b63"
# the website's five-stop viridis
VIRIDIS = LinearSegmentedColormap.from_list("site_viridis", ["#440154", "#3b528b", "#21918c", "#5ec962", "#fde725"])
plt.rcParams.update({"font.family": "sans-serif", "font.sans-serif": ["IBM Plex Sans", "Helvetica", "Arial", "DejaVu Sans"], "font.size": 9,
                     "text.color": FG, "axes.labelcolor": FG, "xtick.color": FG, "ytick.color": FG,
                     "savefig.facecolor": "white", "pdf.fonttype": 42})

# --------------------------------------------------------------------------- jurisdictions
EUROPE = ["Germany", "France", "Italy", "Spain", "Netherlands", "Belgium", "Sweden", "Austria", "Finland", "Ireland",
          "Denmark", "Luxembourg", "Czechia", "Portugal", "Lithuania", "Estonia", "Poland", "Greece", "Hungary",
          "Slovakia", "Slovenia", "Romania", "United Kingdom", "Switzerland"]
LATAM = ["Argentina", "Barbados", "Belize", "Bolivia", "Brazil", "Chile", "Colombia", "Costa Rica", "Cuba", "Dominica",
         "Dominican Republic", "Ecuador", "El Salvador", "Grenada", "Guatemala", "Guyana", "Honduras", "Jamaica",
         "Mexico", "Nicaragua", "Panama", "Paraguay", "Peru", "Saint Lucia", "Trinidad and Tobago", "Uruguay"]
NAME_FIX = {"Madagaskar": "Madagascar", "Czech Republic": "Czechia", "1A": "A1"}
ISO3 = {"Republic of the Congo": "COG", "Democratic Republic of the Congo": "COD", "Cote d'Ivoire": "CIV",
        "Eswatini": "SWZ", "Cabo Verde": "CPV", "Sao Tome and Principe": "STP", "The Gambia": "GMB",
        "Tanzania": "TZA", "Bolivia": "BOL", "United Kingdom": "GBR", "Czechia": "CZE", "Saint Lucia": "LCA",
        "Dominican Republic": "DOM", "Trinidad and Tobago": "TTO"}
# drawn as markers on the maps because their polygons are too small to see
SMALL = {"Cabo Verde": (-23.6, 15.1), "Comoros": (43.9, -11.9), "Mauritius": (57.6, -20.3), "Seychelles": (55.5, -4.6),
         "Sao Tome and Principe": (6.7, 0.3), "Barbados": (-59.5, 13.2), "Dominica": (-61.4, 15.4),
         "Grenada": (-61.7, 12.1), "Saint Lucia": (-61.0, 13.9), "Trinidad and Tobago": (-61.2, 10.7),
         "Luxembourg": (6.1, 49.8), "Malta": (14.4, 35.9)}


def region_of(name):
    if name in EUROPE: return "Europe"
    if name in LATAM: return "Latin America & Caribbean"
    return "Africa"


def iso3(name):
    if name in ISO3: return ISO3[name]
    import pycountry
    try: return pycountry.countries.lookup(name).alpha_3
    except LookupError: return None


# --------------------------------------------------------------------------- data
def load_matrix(path):
    raw = pd.read_excel(path, index_col=0)
    fix = lambda s: NAME_FIX.get(str(s).strip(), str(s).strip())
    raw.index = raw.index.map(fix); raw.columns = raw.columns.map(fix)
    raw = raw.loc[~raw.index.duplicated(), ~raw.columns.duplicated()]
    common = [c for c in raw.index if c in raw.columns]
    df = raw.loc[common, common].astype(object).apply(lambda s: s.map(lambda v: NAME_FIX.get(str(v).strip(), str(v).strip())))
    for c in df.columns: df.loc[c, c] = np.nan            # diagonal treated as missing
    order = sorted(df.index, key=lambda x: (REGIONS.index(region_of(x)), list(df.index).index(x)))
    return df.loc[order, order]


def derive(df):
    N = list(df.index); R = {x: region_of(x) for x in N}
    eu = [x for x in N if R[x] == "Europe"]
    importEU, entropy, outS, inS = {}, {}, {}, {}
    for x in N:
        col = df[x].dropna()
        p = col.value_counts(normalize=True)
        entropy[x] = round(float(-(p * np.log2(p)).sum()), 3)
        importEU[x] = col.loc[[o for o in eu if o != x]].value_counts().idxmax()
        outS[x] = int(sum(WEIGHT.get(v, 0) for v in df.loc[x].dropna()))
        inS[x] = int(sum(WEIGHT.get(v, 0) for v in col))
    corridor = {}
    for a in REGIONS:
        for b in REGIONS:
            sub = df.loc[[x for x in N if R[x] == a], [x for x in N if R[x] == b]]
            corridor[f"{a}→{b}"] = {k: int(v) for k, v in sub.stack().value_counts().items()}
    return dict(names=N, region=R, importEU=importEU, entropy=entropy, corridor=corridor, outStrength=outS, inStrength=inS)


def write_json(df, d, outdir):
    """matrix.json in the format the website's src/landscape/findings.py reads."""
    M = ["".join("." if pd.isna(v) else str(CLASSES.index(v)) for v in df.loc[x]) for x in d["names"]]
    json.dump(dict(d, matrix=M), open(outdir / "matrix.json", "w"), ensure_ascii=False)
    pd.DataFrame({"jurisdiction": d["names"], "region": [d["region"][x] for x in d["names"]],
                  "modal_import_class_from_european_reference_set": [d["importEU"][x] for x in d["names"]],
                  "import_entropy_bits": [d["entropy"][x] for x in d["names"]],
                  "weighted_out_strength": [d["outStrength"][x] for x in d["names"]],
                  "weighted_in_strength": [d["inStrength"][x] for x in d["names"]]}
                 ).to_csv(outdir / "derived_measures.csv", index=False)


def legend_handles(classes=CLASSES):
    return [Patch(facecolor=COL[c], edgecolor="none", label=LABEL[c]) for c in classes]


def save(fig, outdir, name):
    fig.savefig(outdir / f"{name}.png", dpi=300, bbox_inches="tight")
    fig.savefig(outdir / f"{name}.pdf", bbox_inches="tight")
    plt.close(fig); print("wrote", name)


# --------------------------------------------------------------------------- 3a matrix
def fig_matrix(df, d, outdir):
    N = d["names"]; n = len(N)
    img = np.ones((n, n, 3))
    for i, a in enumerate(N):
        for j, b in enumerate(N):
            v = df.loc[a, b]
            if not pd.isna(v): img[i, j] = matplotlib.colors.to_rgb(COL[v])
    fig, ax = plt.subplots(figsize=(12.5, 12.5))
    ax.imshow(img, interpolation="none")
    ax.set_xticks(range(n)); ax.set_yticks(range(n))
    ax.set_xticklabels(N, rotation=90, fontsize=5.6); ax.set_yticklabels(N, fontsize=5.6)
    ax.xaxis.set_ticks_position("top"); ax.tick_params(length=0, pad=2)
    for lab in list(ax.get_xticklabels()) + list(ax.get_yticklabels()):
        lab.set_color(REGION_COL[d["region"][lab.get_text()]])
    ax.set_xticks(np.arange(-.5, n, 1), minor=True); ax.set_yticks(np.arange(-.5, n, 1), minor=True)
    ax.grid(which="minor", color="white", linewidth=0.4); ax.tick_params(which="minor", length=0)
    bounds = np.cumsum([sum(1 for x in N if d["region"][x] == r) for r in REGIONS])[:-1]
    for b in bounds:
        ax.axhline(b - .5, color=FG, lw=1.2); ax.axvline(b - .5, color=FG, lw=1.2)
    for s in ax.spines.values(): s.set_edgecolor(LINE)
    ax.set_xlabel("Destination (receiving jurisdiction)", color=MUTED, labelpad=8)
    ax.set_ylabel("Origin (exporting jurisdiction)", color=MUTED, labelpad=8)
    ax.xaxis.set_label_position("top")
    ax.legend(handles=legend_handles(), loc="upper left", bbox_to_anchor=(0, -0.035), ncol=3, frameon=False, fontsize=8,
              handlelength=1.2, columnspacing=1.6)
    save(fig, outdir, "fig3a_matrix")


# --------------------------------------------------------------------------- 3b network
def fig_network(df, d, outdir):
    N = d["names"]; R = d["region"]
    centers = {"Europe": (250, 300), "Africa": (640, 220), "Latin America & Caribbean": (620, 470)}
    radius = {"Europe": 150, "Africa": 170, "Latin America & Caribbean": 120}
    pos = {}
    for r in REGIONS:
        members = [x for x in N if R[x] == r]
        for k, x in enumerate(members):
            a = 2 * math.pi * k / len(members)
            pos[x] = (centers[r][0] + radius[r] * math.cos(a), centers[r][1] + radius[r] * math.sin(a))
    fig, ax = plt.subplots(figsize=(12, 8.3))
    for c in ["B", "A2", "A1"]:                     # draw B first so enabled pathways sit on top
        for a in N:
            for b in N:
                if a != b and df.loc[a, b] == c:
                    ax.plot([pos[a][0], pos[b][0]], [pos[a][1], pos[b][1]], color=COL[c],
                            lw=0.5 if c == "B" else 1.2, alpha=0.15, solid_capstyle="round", zorder=1)
    smax = max(d["outStrength"][x] + d["inStrength"][x] for x in N)
    for x in N:
        s = d["outStrength"][x] + d["inStrength"][x]
        r = 3 + 9 * math.sqrt(s / smax)
        ax.add_patch(plt.Circle(pos[x], r, facecolor=REGION_COL[R[x]], edgecolor="white", lw=1, zorder=3))
    for r in REGIONS:   # label above the ring, below it for the Latin American ring which overlaps the African one
        dy = radius[r] + 16
        ax.text(centers[r][0], centers[r][1] + (dy if r == "Latin America & Caribbean" else -dy), r, ha="center",
                va="top" if r == "Latin America & Caribbean" else "bottom", fontsize=11, fontweight="600")
    ax.set_xlim(0, 900); ax.set_ylim(620, 0); ax.set_aspect("equal"); ax.axis("off")
    ax.legend(handles=[Line2D([], [], color=COL[c], lw=2 if c != "B" else 1, label=LABEL[c] + f" (weight {WEIGHT[c]})")
                       for c in ["A1", "A2", "B"]]
              + [Line2D([], [], marker="o", ls="", color=REGION_COL[r], markeredgecolor="white", markersize=9, label=r) for r in REGIONS],
              loc="lower left", frameon=False, fontsize=8, ncol=2)
    ax.text(0, 640, "Pathways of class C, D and E are omitted. Node size is the sum of weighted in- and out-strength; "
                    "position on the ring carries no meaning.", color=MUTED, fontsize=8, va="top")
    save(fig, outdir, "fig3b_network")


# --------------------------------------------------------------------------- maps
def load_world():
    import geopandas as gpd, pycountry
    ne = HERE / "map_data_50m"; shp = ne / "ne_50m_admin_0_countries.shp"
    if not shp.exists():
        try:
            ne.mkdir(exist_ok=True)
            z = ne / "ne_50m_admin_0_countries.zip"
            print("downloading Natural Earth 50 m boundaries ...")
            urllib.request.urlretrieve("https://naturalearth.s3.amazonaws.com/50m_cultural/ne_50m_admin_0_countries.zip", z)
            zipfile.ZipFile(z).extractall(ne)
        except Exception as e:
            print("Natural Earth download failed:", e)
    if shp.exists():
        w = gpd.read_file(shp)
        col = next(c for c in ["ADM0_A3", "ISO_A3", "SOV_A3"] if c in w.columns)
        w["iso3"] = w[col].astype(str).str.strip(); return w[w.iso3 != "-99"]
    wa = HERE / "countries-50m.json"
    if not wa.exists():
        sys.exit("No boundaries: allow the Natural Earth download or put world-atlas countries-50m.json next to this script.")
    w = gpd.read_file(wa, layer="countries")
    def a3(num):
        try: return pycountry.countries.get(numeric=str(num).zfill(3)).alpha_3
        except Exception: return None
    w["iso3"] = w["id"].map(a3)
    return w[w.iso3.notna()]


PHI1 = 25  # standard parallel of the website's equirectangular projection


def map_axes(figsize=(13, 7.4)):
    fig, ax = plt.subplots(figsize=figsize)
    ax.set_facecolor(MAP_BG); ax.set_xlim(-128, 60); ax.set_ylim(-58, 72)
    ax.set_aspect(1 / math.cos(math.radians(PHI1))); ax.axis("off")
    return fig, ax


def draw_map(world, values, colour_of, title_note, outdir, name, legend):
    """values: {jurisdiction: value}; colour_of(value) -> colour."""
    fig, ax = map_axes()
    world.plot(ax=ax, color=LAND, edgecolor="white", linewidth=0.3, zorder=1)
    iso = {x: iso3(x) for x in values}
    sub = world[world.iso3.isin(set(iso.values()))].copy()
    sub["c"] = sub.iso3.map({iso[x]: colour_of(values[x]) for x in values})
    sub.plot(ax=ax, color=sub["c"], edgecolor="white", linewidth=0.4, zorder=2)
    world[world.iso3.isin(["USA", "CAN"])].plot(ax=ax, color=NOT_CODED, edgecolor="white", linewidth=0.4, zorder=2)
    for x, (lon, lat) in SMALL.items():
        if x in values:
            ax.plot(lon, lat, "o", ms=5, mfc=colour_of(values[x]), mec="white", mew=0.7, zorder=4)
    fig.text(0.125, 0.07, title_note, color=MUTED, fontsize=8, va="top")
    legend(ax)
    save(fig, outdir, name)


def fig_map_import(world, d, outdir):
    def legend(ax):
        ax.legend(handles=legend_handles() + [Patch(facecolor=NOT_CODED, label="Not coded at country level (United States, Canada)")],
                  loc="lower left", bbox_to_anchor=(0.43, 0.02), frameon=False, fontsize=8)
    draw_map(world, d["importEU"], lambda c: COL[c],
             "Modal class of incoming pathways from the 24-jurisdiction European reference set (23 for members of the set).",
             outdir, "fig3c_import_from_europe", legend)


def fig_map_entropy(world, d, outdir):
    emax = max(d["entropy"].values())
    def legend(ax):
        cax = ax.inset_axes([0.47, 0.08, 0.22, 0.025])
        sm = plt.cm.ScalarMappable(cmap=VIRIDIS, norm=plt.Normalize(0, emax))
        cb = plt.colorbar(sm, cax=cax, orientation="horizontal", ticks=[0, emax])
        cb.ax.set_xticklabels(["0 bits", f"{emax:.2f} bits"], fontsize=8); cb.outline.set_visible(False)
        cax.set_title("Entropy of incoming conditions", fontsize=8, loc="left", color=MUTED, pad=3)
        ax.legend(handles=[Patch(facecolor=NOT_CODED, label="Not coded at country level (United States, Canada)")],
                  loc="lower left", bbox_to_anchor=(0.43, 0.0), frameon=False, fontsize=8)
    draw_map(world, d["entropy"], lambda h: VIRIDIS(h / emax),
             "Shannon entropy over the six classes of each jurisdiction's complete incoming profile; "
             "scale runs to the maximum observed (theoretical maximum log2 6 = 2.585 bits).",
             outdir, "fig3d_import_entropy", legend)


# --------------------------------------------------------------------------- corridors
def fig_corridors(d, outdir):
    keys = [f"{a}→{b}" for a in REGIONS for b in REGIONS]
    fig, ax = plt.subplots(figsize=(9, 4.2))
    for i, k in enumerate(keys):
        o = d["corridor"][k]; t = sum(o.values()); left = 0
        for c in CLASSES:
            if o.get(c):
                ax.barh(i, 100 * o[c] / t, left=left, color=COL[c], height=0.55); left += 100 * o[c] / t
        ax.text(101, i, " · ".join(f"{c} {100*o[c]/t:.1f}%" for c in CLASSES if o.get(c)), va="center", fontsize=7.5, color=MUTED)
    ax.set_yticks(range(len(keys))); ax.set_yticklabels([k.replace("→", " → ") for k in keys], fontsize=8.5)
    ax.invert_yaxis(); ax.set_xlim(0, 100); ax.set_xticks([]); ax.tick_params(length=0)
    for s in ax.spines.values(): s.set_visible(False)
    ax.legend(handles=legend_handles(), loc="upper center", bbox_to_anchor=(0.35, -0.02), ncol=3, frameon=False, fontsize=8)
    save(fig, outdir, "fig_corridors")


# --------------------------------------------------------------------------- main
if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", default=str(HERE / ".." / "jupyter_notebook_figures" / "input_file" / "data-sharing-matrix.xlsx"))
    ap.add_argument("--outdir", default=str(HERE / "output_files"))
    ap.add_argument("--no-maps", action="store_true", help="skip the two maps (no geopandas needed)")
    a = ap.parse_args()
    outdir = Path(a.outdir); outdir.mkdir(parents=True, exist_ok=True)
    df = load_matrix(a.input); d = derive(df)
    counts = df.stack().value_counts()
    print(f"{len(df)} jurisdictions; classes:", dict(counts), "; enabled edges (A1/A2/B):", int(counts.reindex(["A1", "A2", "B"]).sum()))
    write_json(df, d, outdir)
    fig_matrix(df, d, outdir); fig_network(df, d, outdir); fig_corridors(d, outdir)
    if not a.no_maps:
        world = load_world(); fig_map_import(world, d, outdir); fig_map_entropy(world, d, outdir)
