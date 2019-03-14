set -x

CURR_DIR=$(pwd)


#echo "$CURR_DIR"

MY_WALK="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/src/MyWalk.py"
EDGE_LIST_BIOLOGY="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/web-sci/biology.edgelist.csv"
EDGE_LIST_CHEMISTRY="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/web-sci/chemistry.edgelist.csv"
DIM=30
OUTPUT_DIR="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/scripts/"
BIOLOGY_CLASS_FILE="../../web-sci/biology.class.csv"
CHEMISTRY_CLASS_FILE="../../web-sci/chemistry.class.csv"


COMMUNITY="biology"

OUTPUT_FILE="$OUTPUT_DIR/$COMMUNITY-ahead-when-necessary-dim.$DIM"
OUTPUT_FILE_EMD="$OUTPUT_FILE.emd"
OUTPUT_FILE_AUC="$OUTPUT_FILE.auc"

rm "$OUTPUT_FILE_EMD"

python2 "$MY_WALK" --input="$EDGE_LIST_BIOLOGY" --output="$OUTPUT_FILE_EMD" --dimensions="$DIM"

sed -i '1d' "$OUTPUT_FILE_EMD"

Rscript biology-ml.R "$OUTPUT_FILE_AUC" "$OUTPUT_FILE_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"

COMMUNITY="chemistry"

OUTPUT_FILE="$OUTPUT_DIR/$COMMUNITY-ahead-when-necessary-dim.$DIM"
OUTPUT_FILE_EMD="$OUTPUT_FILE.emd"
OUTPUT_FILE_AUC="$OUTPUT_FILE.auc"

rm "$OUTPUT_FILE_EMD"

python2 "$MY_WALK" --input="$EDGE_LIST_CHEMISTRY" --output="$OUTPUT_FILE_EMD" --dimensions="$DIM"

sed -i '1d' "$OUTPUT_FILE_EMD"

Rscript biology-ml.R "$OUTPUT_FILE_AUC" "$OUTPUT_FILE_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"


mv ../*.auc .
mv ../*.emd .