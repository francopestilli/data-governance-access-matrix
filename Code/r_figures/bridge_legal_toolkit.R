library(tidyverse)
library(ggplot2)


palette <- c(
  "#C85D00",
  "#FCBF49",
  "#456F9E",
  "#5B4B8A", 
  "#8B1E2D",
  "#D94A4A")
  
palette2 <- c(
  "#5B8A72",  # green
  "#4E79A7",  # muted blue
  "#9B4F92",  # plum
  "#B24C63", # muted raspberry
  "#B96A33",  # warm rust
  "#D4A72C"
)

nature_palette <- c(
  "#1F77B4",  # blue
  "#2CA02C",  # green
  "#17BECF",  # teal
  "#9467BD",  # purple
  "#BCBD22",  # olive
  "#FF7F0E",  # muted orange
  "#7F7F7F"   # gray
)

nature_muted <- c(
  "#4E79A7",
  "#59A14F",
  "#76B7B2",
  "#B07AA1",
  "#9C755F",
  "#EDC948",
  "#BAB0AC"
)

blue_green_distinct <- c(
  "#1D3557",  # deep navy
  "#2A6F97",  # strong blue
  "#1B998B",  # teal
  "#2D936C",  # green-teal
  "#6BA292",  # sage green
  "#89C2D9",  # lighter blue
  "#A8B5C0"   # gray-blue
)

muted7 <- c(
  "#BFC4C8",   # soft gray
  "#A8B79A",  # sage green
  "#7F9AAE",  # dusty blue
  "#9E95B8",  # muted lavender
  "#B88A8A",  # dusty rose
  "#D4C6A1",  # soft mustard
  "#C9A27E"  # muted tan/orange
  )

sat7 <- c(
  "#16A088",   # teal
  "#2E8B57",  # rich green
  "#2F5DA8",  # deep blue
  "#8E44AD",  # purple
  "#C0392B",  # deep red
  "#E67E22",  # strong orange
  "#D4A017"  # mustard
)

dark_muted <- c(
  "#5F7F7A",   # muted teal
  "#5F7A5C",  #muted forest green
  "#4E6A84",  # muted navy blue
  "#6E648C",  # muted plum
  "#8A5D5D",  # muted burgundy
  "#8C6A52",  # muted brown/orange
  "#9A8A4A"  # muted mustard/olive
)



########################### Tab 1 Figure ###############################################
tab1<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/bridge_tab1.csv')


ggplot(tab1, aes(x = Region, fill = Dominant.legal.category.absorbing.neurodata..select.one.)) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Dominant Legal Category Absorbing Neurodata"
  ) + scale_fill_manual(values = c(
    "#4E79A7",  # blue
    "#F28E2B",  # orange
    "#59A14F",  # green
    "#E15759",
    "#76B7B2",  # teal
    "#EDC948",  # yellow
    "#B07AA1"   # purple# red
  ))+ theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )
  
ggplot(tab1, aes(x = Region, fill = Dominant.legal.category.absorbing.neurodata..select.one.)) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Dominant Legal Category Absorbing Neurodata"
  ) + scale_fill_manual(values=palette)+ theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )

ggplot(tab1, aes(x = Region, fill = Dominant.legal.category.absorbing.neurodata..select.one.)) +
  geom_bar(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    title = "Dominant Legal Category Absorbing Neurodata",
    fill=""
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values=palette) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
  )


########################### Tab 2 Figure ###############################################
tab2<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/bridge_tab2.csv')

ggplot(tab2, aes(x = Region, fill = Primary.lawful.basis.relied.upon..select.dominant.)) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Primary Lawful Basis Relied Upon"
  ) + scale_fill_manual(values = nature_muted)+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )

ggplot(tab2, aes(x = Region, fill = Primary.lawful.basis.relied.upon..select.dominant.)) +
  geom_bar(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "",
    title="Primary Lawful Basis Relied Upon"
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = palette) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
  )

########################### Tab 3 Figure ###############################################
tab3<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/bridge_tab3.csv')

table(tab3$Cross.border.transfer.regime.)

ggplot(tab3, aes(x = Region, fill = Cross.border.transfer.regime.)) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Cross-border Transfer Regime"
  ) + scale_fill_manual(values = c(
    "#4A6862",
    "#7A9A8F",
    "#A3B8A9"))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )

ggplot(tab3, aes(x = Region, fill = Cross.border.transfer.regime.)) +
  geom_bar(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "Cross-border Transfer Regime"
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c(
    "#4A6862",
    "#7A9A8F",
    "#A3B8A9")) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )

#read in tab 3 table that is further broken down
tab3_table<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/tab3_table.csv')

tab3_table_long <- tab3_table %>%
  select(
    Region = `Rótulos.de.Linha`,
    Conditionally.permitted,
    Largely.unrestricted,
    Largely.unrestricted..regulatory.absence.,
    Prohibited.by.default
  ) %>%
  pivot_longer(
    cols = -Region,
    names_to = "Legal_Category",
    values_to = "Count"
  )

tab3_table_long$Legal_Category <- factor(
  tab3_table_long$Legal_Category,
  levels = c(
    "Prohibited.by.default",
    "Conditionally.permitted",
    "Largely.unrestricted",
    "Largely.unrestricted..regulatory.absence."
  )
)

ggplot(tab3_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col() +
  labs(
    x = "Region",
    y = "Count",
    fill = "Cross-border Transfer Regime"
  )  +
  scale_fill_manual(values = c(
    "#4A6862",
    "#7A9A8F",
    "#A3B8A9",
    "#C9F4C9"),
    labels = c(
      "Prohibited by default",
      "Conditionally permitted",
      "Largely unrestricted",
      "Largely unrestricted (regulatory absence)")) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )

ggplot(tab3_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col(position = "fill") +
  labs(
    x = "Region",
    y = "Count",
    fill = "",
    title = "Cross-border Transfer Regime"
  )  +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = palette,
    labels = c(
      "Prohibited by default",
      "Conditionally permitted",
      "Largely unrestricted",
      "Largely unrestricted (regulatory absence)")) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
  )

ggplot(tab3_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "",
    title = "Cross-border Transfer Regime"
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(
    values = palette,
    labels = c(
      "Prohibited by default",
      "Conditionally permitted",
      "Largely unrestricted",
      "Largely unrestricted (regulatory absence)"
    )
  ) +
  guides(fill = guide_legend(nrow = 2)) +   # 👈 wrap legend into 2 rows
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
  )

########################### Tab 4 Figure ###############################################
tab4<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/bridge_tab4.csv')


ggplot(tab4, aes(x = Region, fill =Dedicated.oversight.body.exists. )) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Dedicated Oversight Body Exists"
  ) + scale_fill_manual(values = c(
    "#FFFABF",
    "#EDD622"))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )

ggplot(tab4, aes(x = Region, fill = Dedicated.oversight.body.exists.)) +
  geom_bar(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "",
    title="Dedicated Oversight Body Exists"
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = palette) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
  )

########################### Tab 5 Figure ###############################################
tab5<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/bridge_tab5.csv')


ggplot(tab5, aes(x = Region, fill =Enforcement.mechanisms.operational.in.practice. )) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Enforcement Mechanisms Operational in Practice"
  ) + scale_fill_viridis_d(option = "D")+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )

ggplot(tab5, aes(x = Region, fill = Enforcement.mechanisms.operational.in.practice.)) +
  geom_bar(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "Enforcement Mechanisms Operational in Practice"
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = palette) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )

#read in tab 5 table that is further broken down
tab5_table<-read.csv("~/Desktop/tab5_table.csv")

tab5_table_long <- tab5_table %>%
  select(
    Region = `Rótulos.de.Linha`,
    No.evidence,
    No.evidence..regulatory.absence.,
    Rare,
    Rare...exceptional,
    Yes
  ) %>%
  pivot_longer(
    cols = -Region,
    names_to = "Legal_Category",
    values_to = "Count"
  )

tab5_table_long$Legal_Category <- factor(
  tab5_table_long$Legal_Category,
  levels = c(
    "Yes",
    "Rare...exceptional",
    "Rare",
    "No.evidence..regulatory.absence.",
    "No.evidence"
  )
)



ggplot(tab5_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col() +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "Enforcement Operational in Practice"
  )  +
  scale_fill_viridis_d(option = "D", labels = c(
    "Yes",
    "Rare (exceptional)",
    "Rare",
    "No evidence (regulatory absence)",
    "No evidence"))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )


ggplot(tab5_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "",
    title="Enforcement Operational in Practice"
  )  +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = palette, labels = c(
    "Yes",
    "Rare (exceptional)",
    "Rare",
    "No evidence (regulatory absence)",
    "No evidence"))+
  guides(fill = guide_legend(nrow = 2))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
    
  )

########################### Tab 6 Figure ###############################################

tab6<-read.csv('~/Library/CloudStorage/Box-Box/Postdoc/legal_paper_MB/bridge_tab6.csv')

ggplot(tab6, aes(x = Region, fill =Dominant.governance.mode )) +
  geom_bar() +
  labs(
    x = "Region",
    y = "Count",fill= "Data Governance Mode"
  ) + scale_fill_viridis_d(option = "D")+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family="Helvetica"),
    axis.text.y = element_text(size = 14, family="Helvetica"),
    axis.title.x = element_text(size = 18, family="Helvetica", face="bold"),
    axis.title.y = element_text(size = 18, family="Helvetica", face="bold"),
    legend.text = element_text(size=14, family="Helvetica"),
    legend.title = element_text(size=18, family="Helvetica", face="bold")
  )

ggplot(tab6, aes(x = Region, fill = Dominant.governance.mode)) +
  geom_bar(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "Data Governance Mode"
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values =palette) +
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )

#read in tab 6 table that is further broken down
tab6_table<-read.csv("~/Desktop/tab6_table.csv")

tab6_table_long <- tab6_table %>%
  select(
    Region = `Rótulos.de.Linha`,
    Contractual,
    Contractual...private.ordering,
    Contractual...private.ordering..regulatory.absence.,
    Hybrid,
    Public.law
  ) %>%
  pivot_longer(
    cols = -Region,
    names_to = "Legal_Category",
    values_to = "Count"
  )

tab6_table_long$Legal_Category <- factor(
  tab6_table_long$Legal_Category,
  levels = c(
    "Public.law",
    "Hybrid",
    "Contractual...private.ordering..regulatory.absence.",
    "Contractual...private.ordering",
    "Contractual"
  )
)

ggplot(tab6_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col() +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "Enforcement Operational in Practice"
  )  +
  scale_fill_viridis_d(option = "D",
                       labels = c(
                         "Public law",
                         "Hybrid",
                         "Contractual/ private ordering (regulatory absence)",
                         "Contractual/ private ordering",
                         "Contractual"))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )


ggplot(tab6_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    fill = "Enforcement Operational in Practice"
  )  +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_viridis_d(option = "D",
                       labels = c(
                         "Public law",
                         "Hybrid",
                         "Contractual/ private ordering (regulatory absence)",
                         "Contractual/ private ordering",
                         "Contractual"))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold")
  )

ggplot(tab6_table_long, aes(x = Region, y=Count, fill = Legal_Category)) +
  geom_col(position = "fill") +
  labs(
    x = "Region",
    y = "Percentage",
    title = "Enforcement Operational in Practice",
    fill=""
  )  +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = palette,
                       labels = c(
                         "Public law",
                         "Hybrid",
                         "Contractual/ private ordering (regulatory absence)",
                         "Contractual/ private ordering",
                         "Contractual"))+
  guides(fill = guide_legend(nrow = 2))+
  theme_classic() +
  theme(
    axis.text.x = element_text(size = 14, family = "Helvetica"),
    axis.text.y = element_text(size = 14, family = "Helvetica"),
    axis.title.x = element_text(size = 18, family = "Helvetica", face = "bold"),
    axis.title.y = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.text = element_text(size = 14, family = "Helvetica"),
    legend.title = element_text(size = 18, family = "Helvetica", face = "bold"),
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 18, family = "Helvetica", face = "bold", hjust=0.5)
  )

