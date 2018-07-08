from os import listdir
from os.path import isfile, join
import argparse


class Result:
	
	def __init__(self, fileName, auc):		
		if "directed-bfs" in fileName:
			self.method = "simpleWalk"
		if "q0.5-p1.5" in fileName:
			self.method = "node2Vec DFS-like"
		if "q1.5-p0.5" in fileName:
			self.method = "node2Vec BFS-like"
		if "q1-p1" in fileName:
			self.method = "DeepWalk"
		if "line-order-1" in fileName:
			self.method = "LINE First Order"
		if "line-order-2" in fileName:
			self.method = "LINE Second Order"
		if "ahead" in fileName:
			self.method = "Go Ahead When Necessary"
		array = fileName.split(".")
		self.dim = int(array[len(array) - 2])
		array = fileName.split("/")
		self.fileName = array[len(array) - 1]
		self.auc = auc.replace('\n', '')
		array = self.fileName.split("-")
		self.community = array[0]

def export2Html(resultList):
	communityList = getCommunities(resultList)
	dimensionList = getDimensions(resultList)
	sortedList = sorted(resultList, key=lambda r: r.dim)

	tdTemplate = "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>"
	html = "<html><body><h2>Feature Learning AUC</h2><table  border='1'>"
	html = html + "<tr><th>Community</th><th>Method</th><th>Dimension</th><th>AUC</th><th>File</th></tr>"
	for community in communityList:
		for dim in dimensionList:
			sortedList = [x for x in resultList if x.dim == dim and x.community == community]
			sortedList = sorted(sortedList, key=lambda r: r.fileName)
			for r in sortedList:
				html = html + tdTemplate.format(r.community, r.method, r.dim, r.auc, r.fileName)
	html = html + "</table></body></html>"
	return html

def getCommunities(resultList):
	communityList = []
	for r in resultList:
		if r.community not in communityList:
			communityList.append(r.community)
	return sorted(communityList)

def getDimensions(resultList):
	dimList = []
	for r in resultList:
		if r.dim not in dimList:
			dimList.append(r.dim)
	return sorted(dimList)


def parse_args():
	parser = argparse.ArgumentParser(description="Run Summary")
	parser.add_argument('--folder', dest='folder', type=str, default="")
	return parser.parse_args()


def main(args):
	aucfileList = [join(args.folder, f) for f in listdir(args.folder) if isfile(join(args.folder, f)) and isAUC(join(args.folder, f))]
	resultList = []
	for file in aucfileList:
		with open(file, 'r') as aucFile:
			auc = aucFile.read()
			r = Result(file, auc)
			resultList.append(r)
	html = export2Html(resultList)
	print(html)
	#for r in resultList:
	#	print r.fileName + " " + r.method + " " + r.dim + " " + r.auc + " " + r.community
	#print(len(aucfiles))

def isAUC(filePath):
	if filePath is not None and filePath.endswith(".auc"):
		return True
	return False

if __name__ == "__main__":
	args = parse_args()
	main(args)