set -x

CURR_DIR=$(pwd)


#echo "$CURR_DIR"

FEATURE_LEARNING_NODE_2_VEC="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/src/main.py"
FEATURE_LEARNING_LINE_DIR="/home/thiago/Área de Trabalho/tbp/workspace/LINE/linux/"
EDGE_LIST_BIOLOGY="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/web-sci/biology.edgelist.csv"
EDGE_LIST_CHEMISTRY="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/web-sci/chemistry.edgelist.csv"
DIM=5
OUTPUT_DIR="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/scripts"
BIOLOGY_CLASS_FILE="../../web-sci/biology.class.csv"
CHEMISTRY_CLASS_FILE="../../web-sci/chemistry.class.csv"


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



rm "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD"
rm "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD"
rm "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD"
rm "$OUTPUT_BFS_EMD"
rm "$OUTPUT_LINE_2_EMD"
rm "$OUTPUT_LINE_1_EMD"


cd "$FEATURE_LEARNING_LINE_DIR"
./line -train "$EDGE_LIST_BIOLOGY" -output "$OUTPUT_LINE_2_EMD" -size "$DIM" -order 2
./line -train "$EDGE_LIST_BIOLOGY" -output "$OUTPUT_LINE_1_EMD" -size "$DIM" -order 1

cd "$CURR_DIR"

python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_BIOLOGY" --output="$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD" --dimensions="$DIM" --q=1.5 --p=0.5
python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_BIOLOGY" --output="$OUTPUT_NODE_2_VEC_Q_LST_P_EMD" --dimensions="$DIM" --q=0.5 --p=1.5
python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_BIOLOGY" --output="$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD" --dimensions="$DIM" --q=1 --p=1
python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_BIOLOGY" --output="$OUTPUT_BFS_EMD" --dimensions="$DIM" --executionType=smt 


sed -i '1d' "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD"
sed -i '1d' "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD"
sed -i '1d' "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD"
sed -i '1d' "$OUTPUT_BFS_EMD"
sed -i '1d' "$OUTPUT_LINE_2_EMD"
sed -i '1d' "$OUTPUT_LINE_1_EMD"


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



rm "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD"
rm "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD"
rm "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD"
rm "$OUTPUT_BFS_EMD"
rm "$OUTPUT_LINE_2_EMD"
rm "$OUTPUT_LINE_1_EMD"


cd "$FEATURE_LEARNING_LINE_DIR"
./line -train "$EDGE_LIST_CHEMISTRY" -output "$OUTPUT_LINE_2_EMD" -size "$DIM" -order 2
./line -train "$EDGE_LIST_CHEMISTRY" -output "$OUTPUT_LINE_1_EMD" -size "$DIM" -order 1

cd "$CURR_DIR"

python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_CHEMISTRY" --output="$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD" --dimensions="$DIM" --q=1.5 --p=0.5
python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_CHEMISTRY" --output="$OUTPUT_NODE_2_VEC_Q_LST_P_EMD" --dimensions="$DIM" --q=0.5 --p=1.5
python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_CHEMISTRY" --output="$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD" --dimensions="$DIM" --q=1 --p=1
python2 "$FEATURE_LEARNING_NODE_2_VEC"  --input="$EDGE_LIST_CHEMISTRY" --output="$OUTPUT_BFS_EMD" --dimensions="$DIM" --executionType=smt


sed -i '1d' "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD"
sed -i '1d' "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD"
sed -i '1d' "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD"
sed -i '1d' "$OUTPUT_BFS_EMD"
sed -i '1d' "$OUTPUT_LINE_2_EMD"
sed -i '1d' "$OUTPUT_LINE_1_EMD"


Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_GRT_P_AUC" "$OUTPUT_NODE_2_VEC_Q_GRT_P_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_LST_P_AUC" "$OUTPUT_NODE_2_VEC_Q_LST_P_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_NODE_2_VEC_Q_EQ_P_AUC" "$OUTPUT_NODE_2_VEC_Q_EQ_P_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_BFS_AUC" "$OUTPUT_BFS_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_LINE_2_AUC" "$OUTPUT_LINE_2_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"
Rscript biology-ml.R "$OUTPUT_LINE_1_AUC" "$OUTPUT_LINE_1_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"


# python2 src/main.py  --input=web-sci/chemistry.edgelist.csv --output=web-sci/chemistry-directed-node2vec-q1-p1.emd --dimensions=5 --q=1 --p=1
