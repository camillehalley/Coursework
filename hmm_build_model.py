import pickle
import re
import string
import sys

class hmm_model_build:
    def __init__(self, sent_list):
        self.lowered_sent_list = []
        self.wordTagFreq = {}
        self.bigramFreqPOS = {} #a dictionary of the frequecy with which POS bigrams occur
        self.matrix = {} # a dictionary of dictionaries

        for i in sent_list:
            tempList = []
            for tempTup in i:
                lowerW = tempTup[0]
                lowerW = lowerW.lower()
                newPair = (lowerW, tempTup[1])
                tempList.append(newPair)
            self.lowered_sent_list.append(tempList)

        self.transitionProbability(self.lowered_sent_list)#creat transition frequencies
        self.wordTagFrequency(self.lowered_sent_list)#create emmission frequencies
        self.qMatrix(self.lowered_sent_list)#create matrix

        self.finalData = []
        '''a list of dictionaries, the final item to be saved, will contain
         transition and emmission probabilities as well as a matrix of possible parts of
          speech for a given '''

        for k in self.bigramFreqPOS: #create transition
            self.bigramFreqPOS[k] /= len(self.wordTagFreq)


        for z in self.wordTagFreq:
            self.wordTagFreq[z] /= len(self.wordTagFreq) #CREATE TAG WORD PROBABILITY



        self.finalData.append(self.bigramFreqPOS) #append final data
        self.finalData.append(self.wordTagFreq)
        self.finalData.append(self.matrix)


        with open('model.dat', 'wb') as handle:
            pickle.dump(self.finalData, handle, protocol=pickle.HIGHEST_PROTOCOL)



    def wordTagFrequency(self, sentences):
        '''
        Takes a set of tuple data and returns a dictionary of tuples with values representing how often each work appeared
        as each POS
        '''
        for i in sentences:
            for tempPair in i:
                if tempPair not in self.wordTagFreq:
                    self.wordTagFreq[tempPair] = 1
                else:
                    self.wordTagFreq[tempPair] += 1
        return

    def transitionProbability(self, sentences):
        '''
        Takes a set of tuple data and returns a dictionary of the POS bigrams with values representing how often each
        POS was followed by another POS
        '''
        for j in sentences:
            qoBigram = 'qo ' + j[0][1] #get qo probabilities
            qfBigram = j[-1][1] + ' qf' #get qf probabilities
            if qoBigram not in self.bigramFreqPOS:
                self.bigramFreqPOS[qoBigram] = 1
            else:
                self.bigramFreqPOS[qoBigram] += 1
            if qfBigram not in self.bigramFreqPOS:
                self.bigramFreqPOS[qfBigram] = 1
            else:
                self.bigramFreqPOS[qfBigram] += 1

            for k in range(len(j)-1): #calculate bigram frequencies
                n = (j[k][1])
                n2 = j[k+1][1]
                bigram = n + ' ' + n2
                if bigram not in self.bigramFreqPOS:
                    self.bigramFreqPOS[bigram] = 1
                else:
                    self.bigramFreqPOS[bigram] +=1
        return

    def qMatrix(self, sentences):
        '''

        :param sentences: takes data as list of lists of tuples
        :return: dictionary with list values that correspond to every POS
        '''
        for i in sentences:
            for tempPair in i:
                if tempPair[0] not in self.matrix:
                    self.matrix[tempPair[0]] = {tempPair[1]:1}
                else:
                    if tempPair[1] not in self.matrix[tempPair[0]]:
                        tempDict = {tempPair[1]:1}
                        self.matrix[tempPair[0]].update(tempDict)
        return


def main():
    s = pickle.load(open(sys.argv[1], 'rb'))
    wordProbs = hmm_model_build(s)



if __name__ == '__main__':
    main()

