import java.io.*;
import java.util.*;
import java.text.*;

public class EngMWT

{
// tillstånd för termigenkänning

static final int INIT = 0;
static final int MID = 1;
static final int PREP = 2;


// ordklasser
// borde ligga i ngt api ngnstans, tillsammans med access till
// engmwt.{lex,stop}
static final int OKÄND = 0;
static final int SUBSTANTIV = 1;
static final int ADJEKTIV = 2;
static final int ARTIKEL = 3;
static final int OF = 4;
static final int PREPOSITION = 5;
static final int KONJUNKTION = 6;
static final int PRONOMEN = 7;
static final int ANNAN = 8;
static final int INTERPUNKTION = 9;
static final int TOM = 10;
static final int SKRÄP = 11;

static final Locale här = new Locale("sv","SE");

Hashtable lexikon;
TermTabell mwt;
int threshold;

public static void main(String args[]) {
    if (args.length == 1) {
    try {
      BufferedReader bgf = new BufferedReader(new FileReader(args[0]));
      EngMWT em = new EngMWT(bgf);
em.mwt.skrivUt();
    } catch (IOException e) {
     System.err.println("mwt: Filtjall i mwt.");
    }
}
} // main()


public EngMWT (BufferedReader bgf) {
    lexikon = läslex();
threshold = 2;
mwt = new TermTabell();
    RadFörRad(bgf);
};

public EngMWT (String snutt) {
    lexikon = läslex();
    HelText(snutt);
};



private void RadFörRad(BufferedReader bgf) {
    String aktuellRad = ""; 
    String gammalrad = "";
    String rad;
    int start;
    int end;
    BreakIterator mening = BreakIterator.getSentenceInstance(här);
    try {
      while((rad = bgf.readLine()) != null) {
        aktuellRad = gammalrad+" "+rad.toLowerCase(här);
        mening.setText(aktuellRad);
        start = mening.first();
        for ( end = mening.next();
              end != BreakIterator.DONE;
              start = end, end = mening.next()) {
              if (aktuellRad.length() > end) {
                  körhelameningen(aktuellRad.substring(start,end));
              } else {
                  gammalrad = aktuellRad.substring(start,end);
              }
        }
        }
    } catch (IOException e) {
     System.err.println("mwt: Filtjall i mwt.");
    }

    körhelameningen(aktuellRad);
  }

private void HelText(String snutt) {
    String aktuellRad = snutt.toLowerCase(); 
    int start;
    int end;
    BreakIterator mening = BreakIterator.getSentenceInstance(här);
    mening.setText(aktuellRad);
    start = mening.first();
    for ( end = mening.next();
          end != BreakIterator.DONE;
          start = end, end = mening.next()) {
               körhelameningen(aktuellRad.substring(start,end));
        }
}

private void körhelameningen(String aktuellMening) {
	String fras = "";
        String aktuelltOrd;
        int aktuelltPos;
        int state = INIT;
        int start = 0;
        int startO = 0;
        int endO = 0;
	BreakIterator ord = BreakIterator.getWordInstance(här);
        ord.setText(aktuellMening);
        startO = ord.first();
ordsnurra:
                 for (endO = ord.next();
                      endO != BreakIterator.DONE;
                      startO = endO, endO = ord.next()) {
                      aktuelltOrd = aktuellMening.substring(startO,endO);
                      aktuelltPos = pos(aktuelltOrd);
if (aktuelltPos == TOM) {continue ordsnurra;};
switch (state) {
case INIT:
                      if (aktuelltPos <= ARTIKEL) {
                          fras = aktuelltOrd;
                          state = MID;
                      };
                      break;
case MID:
                      if (aktuelltPos < ARTIKEL) {
                          fras = fras+" "+aktuelltOrd;
                      };
                      if (aktuelltPos == PREPOSITION) {
                          fras = fras+" "+aktuelltOrd;
                          state = PREP;
                      };
                      if (aktuelltPos == OF) {
                          fras = fras+" "+aktuelltOrd;
                          state = PREP;
                      };
                      if (aktuelltPos == ARTIKEL) {
                          plockaIsär(fras);
                          start = startO;
                          state = INIT; 
                      };
                      if (aktuelltPos > PREPOSITION) {
                          plockaIsär(fras);
                          start = endO;
                          state = INIT; 
                      };
                      break;
case PREP:
                      if (aktuelltPos <= ARTIKEL) {
                          fras = fras+" "+aktuelltOrd;
                          state = MID;
                      } else {
                          plockaIsär(fras);
                          start = endO;
                          state = INIT; 
                      };
                      break;
               };
     }
}


private void plockaIsär (String fras) {
        String aktuellFras;
int start1 = 0;
int start2 = 0;
int end1 = 0;
int end2 = 0;
int n = 0;
int m = 0;
	         BreakIterator ord1 = BreakIterator.getWordInstance(här);
	         BreakIterator ord2 = BreakIterator.getWordInstance(här);
                 ord1.setText(fras); 

                 start1 = ord1.first();
                 for (end1 = ord1.next();
                      end1 != BreakIterator.DONE;
                      start1 = end1, end1 = ord1.next()) {
                      if (pos(fras.substring(start1,end1)) < INTERPUNKTION) {n++;};
                };

                 if (n < threshold) {return;};
                 start1 = ord1.first();
ytter:
                 for (end1 = ord1.next();
                      end1 != BreakIterator.DONE;
                      start1 = end1, end1 = ord1.next()) {
                if (pos(fras.substring(start1,end1)) > ANNAN) {continue ytter;};
                if (pos(fras.substring(start1,end1)) <= ARTIKEL) {
                      m = n;
                      aktuellFras = fras.substring(start1);
                      ord2.setText(aktuellFras);
                      end2 = ord2.last();
                      for (start2 = ord2.previous();
                      start2 != BreakIterator.DONE;
                      end2 = start2, start2 = ord2.previous()) {
                      if (m >= threshold && pos(aktuellFras.substring(start2,end2)) < ARTIKEL) {
//                             System.out.println(aktuellFras.substring(0,end2)+" "+m);
                       mwt.increment(aktuellFras.substring(0,end2),m);
                         }
                      if (pos(aktuellFras.substring(start2,end2)) < INTERPUNKTION) {m--;};
                      }
                      }
                    n--;
                         }

}


public int pos(String ord) {
	if (this.lexikon.containsKey(ord)) { 
	return Integer.parseInt((String)this.lexikon.get(ord));
	} else {
if (ord.equals(" ")) {return TOM; } else {	return OKÄND;};
	};
}

private static Hashtable läslex() {return läslex("engmwt.lex","engmwt.stop");};

private static Hashtable läslex(String lexikonfil, String stopplistfil) {
Hashtable lexikon = new Hashtable();
    String par = "";
    String lexem = "";
    String pos = "";
    int mellanrum = 0;
    try {
      BufferedReader bgf = new BufferedReader(new FileReader(lexikonfil));
      while((par = bgf.readLine()) != null) {
	mellanrum = par.lastIndexOf(' ');
	lexem = par.substring(0,mellanrum);
	pos = par.substring(mellanrum+1);
	lexikon.put(lexem,pos);
      }
      bgf = new BufferedReader(new FileReader(stopplistfil));
      while((lexem = bgf.readLine()) != null) {
	lexikon.put(lexem,"11");
      }
    } catch (IOException e) {
      System.err.println("mwt.java: Hittar inte lexikon.");
    }
return lexikon;
  } // läslex


}
