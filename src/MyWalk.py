import argparse
import numpy as np
import networkx as nx
import Queue
from gensim.models import Word2Vec
import random

class BFS():

	def __init__(self, G, stopLevel, rootNode):
		self.G = G
		self.stopLevel = stopLevel
		self.rootNode = rootNode

	def execute(self):
		#print 'I want to stop at level ' + str(self.stopLevel) + ', starting from node ' + str(self.rootNode)

		toBeVisitedList = Queue.Queue()
		visitedDict = dict()
		path = dict()
		#idea: path[child] = parent
		path[self.rootNode] = None

		toBeVisitedList.put(self.rootNode)
		visitedDict[self.rootNode] = 'visited'
		level = 0
		node = None
		while not toBeVisitedList.empty():	
			node = toBeVisitedList.get()	
			if self.isGoal(level):
				break

			neighbors = self.getUnvisitedChildNode(node, visitedDict)
			if(len(neighbors) > 0):
				level += 1
			for n in neighbors:
				visitedDict[n] = 'visited'
				toBeVisitedList.put(n)
				path[n] = node

		walks = []
		for node in visitedDict.keys():
			p = self.constructPath(node, path)
			if(len(p) > 1):
				walks.append(p)
		return walks

				
	def constructPath(self, node, path):
		#print path
		#print node
		realPath = list()
		if node is None:
			return realPath  
		realPath.append(node)		
		while path[node] is not None:
			realPath.append(path[node])  
			node = path[node]
		
		realPath.reverse()
		#creating the path back
		index = len(realPath) - 2
		while index > -1:
			realPath.append(realPath[index])
			index -= 1
		return realPath	
	

	def isGoal(self, level):
		reached = (level == self.stopLevel)
		return reached 
		
	def getUnvisitedChildNode(self, node, visitedDict):
		unvisitedNodes = []
		neighbors = sorted(self.G.neighbors(node))
		for n in neighbors:
			if(visitedDict.get(n) is None):
				unvisitedNodes.append(n)
		return unvisitedNodes




class DegreeDesc():
	def __init__(self, G):
		self.G = G
		self.calc()
		print 'Min degree of G: ' + str(self.minDegree)
		print 'Avg degree of G: ' + str(self.avgDegree)
		print 'Max degree of G: ' + str(self.maxDegree)

	def calc(self):
		nodeList = self.G.nodes()
		sumDegree = 0
		minDegree = None
		maxDegree = None
		for node in nodeList:
			degree = self.G.degree(node)
			sumDegree = sumDegree + degree
			if(minDegree is None):
				minDegree = degree
			if(maxDegree is None):
				maxDegree = degree
			if(degree < minDegree):
				minDegree = degree
			if(degree > maxDegree):
				maxDegree = degree
		self.minDegree = minDegree
		self.avgDegree = sumDegree / self.G.number_of_nodes()
		self.maxDegree = maxDegree
	

def parse_args():
	parser = argparse.ArgumentParser(description="Run my walk test")
	parser.add_argument('--input', nargs='?', default='graph/karate.edgelist',
	                    help='Input graph path')
	parser.add_argument('--output', nargs='?', default='emb/karate.emb',
	                    help='Embeddings path')
	parser.add_argument('--dimensions', type=int, default=128,
	                    help='Number of dimensions. Default is 128.')
	parser.add_argument('--window-size', type=int, default=10,
                    	help='Context size for optimization. Default is 10.')
	parser.add_argument('--iter', default=1, type=int,
                      help='Number of epochs in SGD')
	parser.add_argument('--workers', type=int, default=8,
	                    help='Number of parallel workers. Default is 8.')
	return parser.parse_args()


def simpleWalk(G, startNode):
	walk = []
	neighbors = sorted(G.neighbors(startNode))
	if(len(neighbors) > 0):
		for n in neighbors:
			walk.append(startNode)
			walk.append(n)
	#else:
	#	walk.append(startNode)
	return walk

def stimulateWalks(G):
	walks = []
	degreeDesc = DegreeDesc(G)
	nodeList = list(G.nodes())
	random.shuffle(nodeList)
	numNodesDegreeLowerAvg = 0
	numNodesDegreeGreaterAvg = 0
	countGoAhead = 0
	countNoAhead = 0
	for node in nodeList:	
		goAhead = False
		if G.degree(node) <= degreeDesc.avgDegree:
			numNodesDegreeLowerAvg += 1
			if G.degree(node) <= (degreeDesc.avgDegree):
				goAhead = True
				
		else:
			numNodesDegreeGreaterAvg += 1
		partialWalks = simpleWalk(G,  node)
		walks.append(partialWalks)
		
		if goAhead:
			countGoAhead += 1
			bfs = BFS(G, 8, node)
			partialWalks = bfs.execute()
			partialWalks.reverse()
			count = 0
			for w in  partialWalks:
				walks.append(w)
				count += 1
				if(count > 3):
					break
		else:
			countNoAhead += 1

	percentDegreeLowerAvg = numNodesDegreeLowerAvg * 100.0/G.number_of_nodes()
	percentDegreeGreaterAvg = numNodesDegreeGreaterAvg * 100.0/G.number_of_nodes()
	
	print('Porcentagem degree abaixo da media ' + str(percentDegreeLowerAvg))
	print('Porcentagem degree acima da media ' + str(percentDegreeGreaterAvg))
	print('Contagem go-ahead ' + str(countGoAhead))
	print('Contagem no-ahead ' + str(countNoAhead))

	#if percentDegreeLowerAvg > 80:
	#	print 'BSF max level 2'
	#else:
	#	print 'BSF max level 4'
	
	return walks

def read_graph():	
	G = nx.read_edgelist(args.input, nodetype=int, create_using=nx.DiGraph())
	for edge in G.edges():
		G[edge[0]][edge[1]]['weight'] = 1
	return G

def learn_embeddings(walks):
	walks = [map(str, walk) for walk in walks]
	model = Word2Vec(walks, size=args.dimensions, window=args.window_size, min_count=0, sg=1, workers=args.workers, iter=args.iter)
	#model.save_word2vec_format(args.output)
	model.wv.save_word2vec_format(args.output)

	return


def main(args):
	G = read_graph()
	walks = stimulateWalks(G)
	print("Starting learning")
	learn_embeddings(walks)
	print("Finish")

if __name__ == "__main__":
	args = parse_args()
	main(args)