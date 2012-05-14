#########################################################################################
""" Using Part-of-speech transition tagging to infer syntax
"""
#########################################################################################
# -*- coding: utf-8 -*-

import TaggedCorpus # loads a corpus with tags such as N, V, DET, PREP...


        
##########################################################
# Hidden Markov Model                                    #
##########################################################

# Note: in this programme, 'Tag' and 'POS' (part-of-speech) are synonymous

##########################################################
# Viterbi Algorithm                                      #
##########################################################
class Viterbi:
    """ Implements Viterbi algorithm
    """
    def __init__(self, Words, Tags, Tag_pr, Transition_pr, Emission_pr):
        self.Words = Words  # all the different words found in the corpus
        self.Tags= Tags     # all the (simplified) tags found in the corpus
        self.Tag_pr = Tag_pr    # Tag probabilities
        self.Transition_pr = Transition_pr  # Probability of transitions between tags
        self.Emission_pr = Emission_pr  # Probability of a word knowing the tag
        

    def ViterbiParse(self, Input):
        " Infers syntactic categories in Input, using transition probabilities "
        FirstWord = Input[0]  
        # The Tag probability Table is a list of dicts
        # It is initialized as Pr(Word|Tag) * Pr(Tag)
        Tag_Pr_Table = [ dict([ (T, self.Emission_pr[FirstWord, T] * self.Tag_pr[T]) for T in self.Tags]) ]
        PathToTag = dict([(T,[T]) for T in self.Tags])  # contains paths as lists
        
        for t in range(1,len(Input)): # t means 'time'
            # For each input tagged word, a posteriori tag probabilities are updated
            NewTagPosteriors = dict()
            NewPathToTag = dict()
            
            for T in self.Tags:
                # Recursive computation of Tag probability
                # One looks for the Tag sequence that maximizes Pr(TagSequence & WordSequence)
                # Since we have limited memory, the probability of the current Tag is retrieved
                # from the probability of PreviousTag and from the transition from PreviousTag to Tag.
                # Max Pr(Word & Tag_sequence) =
                # Max( Pr(PreviousTag) * Pr(Tag|PreviousTag) ) * Pr(Word|Tag)
                # The PreviousTag that maximizes Pr(Word & Tag_sequence) also
                # maximizes Pr(Tag_sequence | Word)

                # determine the best PreviousTag (call it BestPTag)
                # and its associated probability (call it prob)
                # using the (already computed and stored) probability of candidates PreviousT:
                # Tag_Pr_Table[t-1][PreviousT]

                ########## TO BE DONE ############
                (prob, BestPTag) = (1, 'N')

                NewTagPosteriors[T] = prob  # one stores the probability of tag T for the current word 
                NewPathToTag[T] = PathToTag[BestPTag] + [T] # one stores the best path leading to T
                
            Tag_Pr_Table.append(NewTagPosteriors)
            PathToTag = NewPathToTag    # best paths to the current word

        # retrieving best global result
        (prob, BestTag) = max([ (Tag_Pr_Table[len(Input)-1][LastTag] , LastTag)
                              for LastTag in self.Tags])
        return (prob, PathToTag[BestTag])

class HiddenMarkovModel:
    """ Builds a hidden Markov model from a corpus
    """

    def __init__(self):        
        self.TaggedText = []  # list of (word, tag, simpleTag) triplets
        self.SimpleTags = set()
        self.Words = set()
        self.PosProbability = dict()            # Absolute probability of Parts-of-Speech (tags)
        self.PosTransitionProbability = dict()  # Transition probability table
        self.WordAsPosProbability = dict()      # Emission probability table
        self.Viterbi = None
        self.Parse = None

    def ExploitCorpus(self, Corpus):
        self.RetrieveCorpus(Corpus)
        self.GetProbabilities()
        self.Viterbi = Viterbi(self.Words, self.SimpleTags, self.PosProbability, self.PosTransitionProbability, self.WordAsPosProbability)
        self.Parse = self.Viterbi.ViterbiParse

        
    def RetrieveCorpus(self, Corpus):
        # retrieve tagged text
        self.TaggedText = Corpus  # list of (word, tag, simpleTag) triplets
        self.SimpleTags = set([TW[2] for TW in self.TaggedText])    # simple tags actually used
        self.Words = set([TW[0] for TW in self.TaggedText])

        
    def GetProbabilities(self):
        " Creation of transition and emision probability tables  "
        for T1 in self.SimpleTags:
            self.PosProbability[T1] = 0.0   
            for T2 in self.SimpleTags:
                self.PosTransitionProbability[(T1, T2)] = 0.0   # important to have a float
            for W in self.Words:
                self.WordAsPosProbability[(W, T1)] = 0.0        # important to have a float

        print '\tcounting words and transitions...'
        PreviousTaggedWord = None
        for TaggedWord in self.TaggedText:
            if PreviousTaggedWord:
                self.PosTransitionProbability[(PreviousTaggedWord[2], TaggedWord[2])] += 1
            PreviousTaggedWord = TaggedWord
            self.WordAsPosProbability[(TaggedWord[0], TaggedWord[2])] += 1
            self.PosProbability[TaggedWord[2]] += 1
            
        ##print '10 most probable transitions'
        ##print sorted(self.PosTransitionProbability.items(), key=lambda x: x[1], reverse=True)[:10]
        ##print '10 most probable words'
        ##print sorted(self.WordAsPosProbability.items(), key=lambda x: x[1], reverse=True)[:10]

        print '\tnormalization...'
        NumberOfTags = sum([self.PosProbability[T] for T in self.SimpleTags])
        for T1 in self.SimpleTags:
            if NumberOfTags:    self.PosProbability[T1] /= NumberOfTags
            NumberOfOccurrences = sum([self.PosTransitionProbability[(T1, T)] for T in self.SimpleTags])
            if NumberOfOccurrences:
                for T2 in self.SimpleTags:
                    self.PosTransitionProbability[(T1,T2)] /= NumberOfOccurrences
            else:   print 'Error: Empty tag %s !!!' % T1
        for W in self.Words:
            NumberOfOccurrences = sum([self.WordAsPosProbability[(W, T)] for T in self.SimpleTags])
            if NumberOfOccurrences:
                for T in self.SimpleTags:
                    self.WordAsPosProbability[(W, T)] /= NumberOfOccurrences
            else:   print 'Nonexistent Word %s !!!' % W

        # Display significant transitions
##        print 'Significant transitions:'
##        for (T1, T2) in self.PosTransitionProbability:
##            if self.PosTransitionProbability[(T1, T2)] > 0.2:
##                print '%s --> %s: %f' % (T1, T2, self.PosTransitionProbability[(T1, T2)])

        #for (W, T) in sorted(self.WordAsPosProbability):
        #    if self.WordAsPosProbability[(W, T)] > 0.3:
        #      if self.WordAsPosProbability[(W, T)] < 0.7:
        #        print '%s ==> %s: %f' % (W, T, self.WordAsPosProbability[(W, T)])

        # Most probable POS
        ##print sorted([(T,self.PosProbability[T]) for T in self.SimpleTags], key=lambda x: x[1], reverse=True)[:10]


    def BasicParse(self, WordList):
        "   Basic parsing: each word is given its most probable category "
        CumulatedProbability = 1.0
        TagList = WordList
        i = 0
        for W in TagList:
          WordBestMatch = sorted([(T, self.WordAsPosProbability[(W, T)]) for T in self.SimpleTags], key=lambda x: x[1], reverse=True)[0]
          print "%s: %s (%f)" % (W, WordBestMatch[0], WordBestMatch[1])
          CumulatedProbability *= WordBestMatch[1]
          TagList[i] = WordBestMatch[0]
          i += 1
        return (CumulatedProbability, TagList)




if __name__ == '__main__':
    print __doc__
    CorpusName = 'Total.dat'
    Corpus = TaggedCorpus.Corpus(CorpusName)
    print 'Importing tagged text from %s: \n"%s . . .' % (CorpusName, Corpus.Text()[:400])
    print '. . . %s"' % Corpus.Text()[-400:]
    HMM = HiddenMarkovModel()
    print "Building HMM from %s" % CorpusName
    HMM.ExploitCorpus(Corpus.TaggedText())

    Tests = [
        'the primary election took place yesterday',
        'The Fulton County Grand Jury said Friday an investigation of Atlanta recent primary election produced evidence that any irregularities took place',
        'the election was conducted',
        'Our pin clips and self nuts achieved dominance in just a few years time despite substantial well established competition',
        'He clips that and I place it'
        ]
    for Sentence in Tests:
        (prob, analysis) = HMM.Parse(Sentence.split())
        print
        print Sentence
        print analysis
        print prob
    print "Probability for 'place' to be a noun: %s" % HMM.WordAsPosProbability[('place', 'N')]
    print "Probability for 'place' to be a verb: %s" % HMM.WordAsPosProbability[('place', 'V')]
