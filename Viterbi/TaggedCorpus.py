###############################################################################################
""" Corpus conversion: simplifies a corpus got from http://www.grsampson.net/Resources.html
    using tags defined in http://ucrel.lancs.ac.uk/claws7tags.html
"""
###############################################################################################


print """
... Tagged corpus loaded (locally, but originally from http://www.grsampson.net/Resources.html )
Available functions are:
    TaggedText(CorpusName):   returns (word, tag, simpleTag) triplets as words appear in the text
    Text():         returns a readable version of the text
    example(POS):   shows examples of original part-of-speech POS in context
    Tags():         returns all (tag, simpleTag) pairs as dictionnary
    
"""



# Simplification of the original parts of speech set
SimpleTags = dict([
    ('AT', 'DET'),
    ('AT1', 'DET'),
    ('AT1e', 'DET'),
    ('ATn', 'DET'),
    ('BTO21', 'PREP'),
    ('BTO22', 'N'),
    ('CS', 'CS'),
    ('CSi', 'CS'),
    ('CS21', 'ADJ'),
    ('CS22', 'CS'),
    ('CS31', 'PREP'),
    ('CS32', 'ADV'),
    ('CS33', 'PREP'),
    ('DA1', 'DET'),
    ('DA2', 'DET'),
    ('DA2q', 'DET'),
    ('DAg', 'ADJ'),
    ('DAR', 'ADJ'),
    ('DA2R', 'ADJ'),
    ('DAT', 'ADV'),
    ('DAr', 'ADJ'),
    ('DAy', 'ADJ'),
    ('DAz', 'DET'),
    ('DB2', 'DET'),
    ('DBa', 'ADV'),
    ('DBh', 'N'),
    ('DD1a', 'DET'),
    ('DD1b21', 'DET'),
    ('DD1b22', 'N'),
    ('DD1e', 'N'),
    ('DD1n', 'N'),
    ('DD1t21', 'DET'),
    ('DD1t22', 'N'),
    ('DDo21', 'DET'),
    ('DDo22', 'N'),
    ('DD1i', 'DET'),
    ('DD1q', 'DET'),
    ('DD1q41', 'DET'),
    ('DD1q42', 'COORD'),
    ('DD1q43', 'DET'),
    ('DD1q44', 'ADJ'),
    ('DD21', 'DET'),
    ('DD22', 'N'),
    ('DD221', 'DET'),
    ('DD222', 'N'),
    ('DD231', 'DET'),
    ('DD232', 'ADJ'),
    ('DD233', 'ADV'),
    ('DD2a', 'DET'),
    ('DD2i', 'DET'),
    ('DDf', 'ADV'),
    ('DDQ', 'CS'),
    ('DDQGq', 'CS'),
    ('DDQGr', 'CS'),
    ('DDQq', 'CS'),
    ('DDQr', 'CS'),
    ('DDQV', 'ADV'),
    ('DDQV31', 'ADV'),
    ('DDQV32', 'N'),
    ('DDQV33', 'CS'),
    ('DDi', 'PRO'),
    ('DDo', 'ADV'),
    ('DDy', 'PRO'),
    ('EX', 'PRO'),
    ('FA', 'ADV'),
    ('FB', 'ADJ'),
    ('FW', 'N'),
    ('FWg', 'N'),
    ('FWs', 'ADJ'),
    ('GG', 'SPACE'),
    ('ICS', 'ADV'),
    ('ICSx', 'ADV'),
    ('II21', 'ADV'),
    ('LE', 'ADV'),
    ('LE21', 'NEG'),
    ('LE22', 'ADV'),
    ('LEe', 'COORD'),
    ('LEn', 'COORD'),
    ('MC', 'ADJ'),
    ('MC1', 'ADJ'),
    ('MC1n', 'SPACE'),
    ('MC2', 'PRO'),
    ('MC2y', 'N'),
    ('MCb', 'SPACE'),
    ('MCd', 'SPACE'),
    ('MCe', 'SPACE'),
    ('MFn', 'SPACE'),
    ('MCr', 'ADJ'),
    ('MCn', 'ADJ'),
    ('MCo', 'SPACE'),
    ('MCy', 'NP'),
    ('MD', 'ADJ'),
    ('MDn', 'ADJ'),
    ('MDo', 'ADJ'),
    ('MDt', 'ADJ'),
    ('ND1', 'ADV'),
    ('NNOc', 'ADJ'),
    ('TO', 'INFL'),
    ('UH', 'NP'),
    ('UH21', 'V'),
    ('UH22', 'PRO'),
    ('XX', 'NEG'),
    ('ZZ1', 'SPACE')
                   ])

def SimplifyTags(Tag):
    if Tag in SimpleTags:   return SimpleTags[Tag]  # priority to exceptions
    if Tag.startswith('APP'): SimpleTags[Tag] = 'PRO'
    if Tag.startswith('CC'): SimpleTags[Tag] = 'COORD'
    if Tag.startswith('CS'): SimpleTags[Tag] = 'CS'
    if Tag.startswith('FO'): SimpleTags[Tag] = 'SPACE'
    if Tag.startswith('I'): SimpleTags[Tag] = 'PREP'
    if Tag.startswith('J'): SimpleTags[Tag] =  'ADJ'
    if Tag.startswith('N'): SimpleTags[Tag] =  'N'
    if Tag.startswith('PP'): SimpleTags[Tag] =  'PRO'
    if Tag.startswith('PN'): SimpleTags[Tag] =  'PRO'
    if Tag.startswith('R'): SimpleTags[Tag] =  'ADV'
    if Tag.startswith('V'): SimpleTags[Tag] =  'V'
    if Tag.startswith('Y'): SimpleTags[Tag] =  'SPACE'
    if Tag in SimpleTags:   return SimpleTags[Tag]
    else:   return None


class Corpus:
    """ Loads a corpus in memory
    """

    def __init__(self, CorpusName):
        self.CorpusAsListOfTaggedWords = [] # List of tuples repesenting tagged words from a text
        self.PartsOfSpeech = [] # All parts of speech present in the tagged text
        self.load(CorpusName)

    def load(self, CorpusName):       
        # retrieve the corpus
        self.CorpusAsListOfTaggedWords = map(lambda S:S.split('\t'), open(CorpusName).readlines())
        # list of parts of speech actually used in the corpus
        self.PartsOfSpeech = sorted(list(set([W[2] for W in self.CorpusAsListOfTaggedWords])))


    def example(self, POS):
        " shows examples of Part-Of-Speech POS in the corpus "
        Examples = [(self.CorpusAsListOfTaggedWords.index(W), W[3], W[2]) for W in self.CorpusAsListOfTaggedWords if W[2] == POS]
        for E in Examples:
            Index = E[0]
            print '\n'.join([W[3]+'\t'+W[2] for W in self.CorpusAsListOfTaggedWords[Index-3 : Index+3]])
            print
            print ' '.join([W[3] for W in self.CorpusAsListOfTaggedWords[Index-10 : Index+10]])
            print
    
    def Text(self):
        # gets text without tags, omitting (most) formatting tags
        T = ' '.join([W[3] for W in self.CorpusAsListOfTaggedWords])
        T = T.replace('+','')
        T = T.replace('<hyphen>','-')
        T = T.replace('<minbrk>','\n')
        T = T.replace(' <apos>',"'")
        T = T.replace('<apos>',"'")
        T = T.replace('<ldquo> ','"')
        T = T.replace(' <rdquo>','"')
        return T


    def TaggedText(self):
        print 'Missing tags:', sorted(list(set([ W[2] for W in self.CorpusAsListOfTaggedWords if not SimplifyTags(W[2]) ]) ))
        try:
            return [(W[3], W[2], SimpleTags[W[2]]) for W in self.CorpusAsListOfTaggedWords]
        except KeyError, Msg:
            print 'Error. Unknown tag: %s' % Msg
            raise KeyError

    def Tags(self):
        return self.SimpleTags.items()


    
if __name__ == "__main__":
    print __doc__
##    C = Corpus('A01_SNS.dat')
    C = Corpus('Total.dat')
    print '\n'.join([str(T) for T in C.TaggedText()[:30] if T[2] != 'SPACE'])
    print 'Number of different original tags: ', len(SimpleTags)
    print '\n . . .\n'

##    open('Total.txt','w').write(C.Text())
                               
