set -x

CURR_DIR=$(pwd)


#echo "$CURR_DIR"

DIM=20
OUTPUT_DIR="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/scripts/top20"
BIOLOGY_CLASS_FILE="biology.class.csv"
CHEMISTRY_CLASS_FILE="chemistry.class.csv"


COMMUNITY="biology"

OUTPUT_NODE_2_VEC_Q_GRT_P="$OUTPUT_DIR/$COMMUNITY-directed-node2vec-q1.5-p0.5-dim.$DIM"
OUTPUT_NODE_2_VEC_Q_LST_P="$OUTPUT_DIR/$COMMUNITY-directed-node2vec-q0.5-p1.5-dim.$DIM"
OUTPUT_NODE_2_VEC_Q_EQ_P="$OUTPUT_DIR/$COMMUNITY-directed-node2vec-q1-p1-dim.$DIM"
OUTPUT_BFS="$OUTPUT_DIR/$COMMUNITY-directed-bfs-dim.$DIM"
OUTPUT_LINE_2="$OUTPUT_DIR/$COMMUNITY-line-order-2-dim.$DIM"
OUTPUT_LINE_1="$OUTPUT_DIR/$COMMUNITY-line-order-1-dim.$DIM"


OUTPUT_NODE_2_VEC_Q_GRT_P_EMD="$OUTPUT_NODE_2_VEC_Q_GRT_P.emd"
OUTPUT_NODE_2_VEC_Q_LST_P_EMD="$OUTPUT_NODE_2_VEC_Q_LST_P.emd"
OUTPUT_NODE_2_VEC_Q_EQ_P_EMD="$OUTPUT_NODE_2_VEC_Q_EQ_P.emd"
OUTPUT_BFS_EMD="$OUTPUT_BFS.emd"
OUTPUT_LINE_2_EMD="$OUTPUT_LINE_2.emd"
OUTPUT_LINE_1_EMD="$OUTPUT_LINE_1.emd"


OUTPUT_NODE_2_VEC_Q_GRT_P_AUC="$OUTPUT_NODE_2_VEC_Q_GRT_P.auc"
OUTPUT_NODE_2_VEC_Q_LST_P_AUC="$OUTPUT_NODE_2_VEC_Q_LST_P.auc"
OUTPUT_NODE_2_VEC_Q_EQ_P_AUC="$OUTPUT_NODE_2_VEC_Q_EQ_P.auc"
OUTPUT_BFS_AUC="$OUTPUT_BFS.auc"
OUTPUT_LINE_2_AUC="$OUTPUT_LINE_2.auc"
OUTPUT_LINE_1_AUC="$OUTPUT_LINE_1.auc"



Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_GRT_P_AUC" "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_LST_P_AUC" "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_EQ_P_AUC" "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_BFS_AUC" "$OUTPUT_BFS_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_LINE_2_AUC" "$OUTPUT_LINE_2_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_LINE_1_AUC" "$OUTPUT_LINE_1_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"


#chemistry community

COMMUNITY="chemistry"

OUTPUT_NODE_2_VEC_Q_GRT_P="$OUTPUT_DIR/$COMMUNITY-directed-node2vec-q1.5-p0.5-dim.$DIM"
OUTPUT_NODE_2_VEC_Q_LST_P="$OUTPUT_DIR/$COMMUNITY-directed-node2vec-q0.5-p1.5-dim.$DIM"
OUTPUT_NODE_2_VEC_Q_EQ_P="$OUTPUT_DIR/$COMMUNITY-directed-node2vec-q1-p1-dim.$DIM"
OUTPUT_BFS="$OUTPUT_DIR/$COMMUNITY-directed-bfs-dim.$DIM"
OUTPUT_LINE_2="$OUTPUT_DIR/$COMMUNITY-line-order-2-dim.$DIM"
OUTPUT_LINE_1="$OUTPUT_DIR/$COMMUNITY-line-order-1-dim.$DIM"


OUTPUT_NODE_2_VEC_Q_GRT_P_EMD="$OUTPUT_NODE_2_VEC_Q_GRT_P.emd"
OUTPUT_NODE_2_VEC_Q_LST_P_EMD="$OUTPUT_NODE_2_VEC_Q_LST_P.emd"
OUTPUT_NODE_2_VEC_Q_EQ_P_EMD="$OUTPUT_NODE_2_VEC_Q_EQ_P.emd"
OUTPUT_BFS_EMD="$OUTPUT_BFS.emd"
OUTPUT_LINE_2_EMD="$OUTPUT_LINE_2.emd"
OUTPUT_LINE_1_EMD="$OUTPUT_LINE_1.emd"


OUTPUT_NODE_2_VEC_Q_GRT_P_AUC="$OUTPUT_NODE_2_VEC_Q_GRT_P.auc"
OUTPUT_NODE_2_VEC_Q_LST_P_AUC="$OUTPUT_NODE_2_VEC_Q_LST_P.auc"
OUTPUT_NODE_2_VEC_Q_EQ_P_AUC="$OUTPUT_NODE_2_VEC_Q_EQ_P.auc"
OUTPUT_BFS_AUC="$OUTPUT_BFS.auc"
OUTPUT_LINE_2_AUC="$OUTPUT_LINE_2.auc"
OUTPUT_LINE_1_AUC="$OUTPUT_LINE_1.auc"



Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_GRT_P_AUC" "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_LST_P_AUC" "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_EQ_P_AUC" "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_BFS_AUC" "$OUTPUT_BFS_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_LINE_2_AUC" "$OUTPUT_LINE_2_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_LINE_1_AUC" "$OUTPUT_LINE_1_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"


# python2 src/main.py  --input=web-sci/chemistry.edgelist.csv --output=web-sci/chemistry-directed-node2vec-q1-p1.emd --dimensions=5 --q=1 --p=1

#mv ../*.auc .
#mv ../*.emd .