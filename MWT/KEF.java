//***************************************************
/*
  Utkast till KEF, Keyword Extraction Function
  Anna Jonsson		
  September 1998
  (soon to be) Version 1.0
  -
  -
  -
 */
  //****************************************************
  
import java.awt.*;
import java.io.*;
import java.util.*;
import java.text.*;
import java.net.*;
import intext;

public class KEF extends Frame
{
  List utdata;
  TextArea indata;
  Button sok;
  Button sok_i;
  Button sluta;
  Label utrubrik, inrubrik, sokrubrik, minutrubrik, eller, traffrub;
  TextField minuter,traffar;
  Vector stoppvekt = new Vector();
  Vector oJavekt = new Vector();
  Vector Javekt = new Vector();
  Vector JaNejvekt1 = new Vector();
  Vector JaNejvekt = new Vector();
  Vector open = new Vector();
  Vector closed;
  URL Utemp;

  Color bakgrund;  
  Color textC; 
  Color rubC; 
  
  intext in;
  
  static int kollAnt, indx;
  
  InputStream inputS = null;
  
  
  public static void main (String arg[])
  {
    new KEF();
  }
  
  public KEF()
  {
    setLayout(new BorderLayout());
    
    bakgrund = new Color(1.0f,0.9f,0.9f);
    textC = new Color(1f,0.8f,0.8f);
    rubC = new Color(0.6f,0.7f,0.7f);
    
    //Skapar översta panelen
    Panel pNorr = new Panel();
    pNorr.setLayout(new FlowLayout());
    pNorr.setBackground(bakgrund);
    Label rubrik = new Label("*** KeywordExtractionFunction ***");
    rubrik.setFont(new Font("Helvetica", Font.BOLD,22));
    pNorr.add(rubrik);
    
    Panel norrpan = new Panel();
    norrpan.setLayout(new BorderLayout());
    norrpan.setBackground(bakgrund);
    inrubrik = new Label(" *** ");
    inrubrik.setFont(new Font("Helvetica", Font.BOLD,12));
    norrpan.add("North", inrubrik);
    
    Panel sydpan = new Panel();
    sydpan.setLayout(new BorderLayout());
    sydpan.setBackground(bakgrund);
    indata = new TextArea(10, 30);
    indata.setBackground(textC);
    indata.setEditable(true);
    sydpan.add("North", indata);
    indata.requestFocus();
    
    Panel inpan = new Panel();
    inpan.setLayout(new BorderLayout());
    inpan.setBackground(bakgrund);
    inpan.add("North", norrpan);
    inpan.add("Center", sydpan);
    
    //Skapar höger panel.
    Panel pOst = new Panel();
    pOst.setLayout(new BorderLayout());
    pOst.setBackground(bakgrund);
    Panel pO = new Panel();
    pO.setLayout(new GridLayout(10, 1));
    pO.setBackground(bakgrund);
    sokrubrik = new Label("    ");
    sok = new Button("Press Button ");
    sok.setBackground(textC);

    sok.setFont(new Font("Helvetica", Font.BOLD,12));
    sluta = new Button("Close");
    sluta.setBackground(textC);
    sluta.setFont(new Font("Helvetica", Font.BOLD,12));
    minutrubrik = new Label(" *** ");
    minutrubrik.setFont(new Font("Helvetica", Font.BOLD,12));
    minuter = new TextField("?", 5);
    eller = new Label("*** KEF *** ");
    eller.setFont(new Font("Helvetica", Font.BOLD,8));
    traffrub = new Label("(C) Anna Jonsson");
    traffrub.setFont(new Font("Helvetica",Font.BOLD,7));
    traffar = new TextField("?",5);

    pO.add(sokrubrik);
    pO.add(sok);
    pO.add(sluta);
    pO.add(minutrubrik);
    pO.add(traffar);
    pO.add(minuter);
    pO.add(eller);
    pO.add(traffrub);
    
    pOst.add("North", pO);
    
    Panel utpan = new Panel();
    utpan.setLayout(new BorderLayout());
    utpan.setBackground(textC);
    utdata = new List(15,false);
    utdata.setBackground(bakgrund);
    utrubrik = new Label(" *** ");
    utrubrik.setFont(new Font("Helvetica", Font.BOLD,12));
    utpan.add("North", utrubrik);
    utpan.add("Center", utdata);
    
    add("North", pNorr);
    add("West", inpan);
    add("East", pOst);
    add("Center", utpan);
    
    resize(777,499);
    sok.requestFocus();
    show();
  }
  
  public boolean handleEvent(Event event)
    {
      if(event.id == Event.WINDOW_DESTROY)
	{
	  avsluta();
      }
    return super.handleEvent(event);
  }
  
  public boolean action(Event event, Object arg)
  {
    if(event.id == Event.WINDOW_DESTROY)
      {
	avsluta();
      }
    else if(event.target == sok)
      {
	ordstat();
      }
    
    else if(event.target == sluta)
      {
	avsluta();
      }
    return super.action(event, arg);
  }
  
  void ut_skrift()
    {
      utdata.clear();
      utdata.addItem("Nu vidtar sökning med relevans-feedback");
    }
  
  void avsluta()
    {
      hide();
      dispose();
      System.exit(0);
    }

  void ordstat()
    {
      // Reading link file at the address below 
      intext sL = new intext("/amd/src/diglib/htdocs/bibliotek/linkSwe/links.txt", this);
      String sto = sL.lasIn();
      sL.adressLas(sto);
      
      // Starts the entire KEF process
      in = new intext(this);
      in.taBortEttor();
      //in.sorteraTotal();
      in.sorteraAlfaBet();
      in.skrivTillUtfil();
      in.skrivUtDokumentVektor();
      in.utData();
    }
}

//Slut på Huvudprogrammet
class intext
{
  KEF n;
  
  File infil = null;
  File fil = null;
  FileInputStream infilStream = null;
  
  FileWriter filWri, fW;
  
  byte b[];
  
  Vector Dvekt = new Vector();
  Vector Total1 = new Vector();
  Vector Total2 = new Vector();
  Vector TotalVektor = new Vector();

  boolean om_Nord = false, om_Aord = false, om_NP = false;

  DecimalFormat doubF2 = new DecimalFormat("0.00");

  String idRef = "";
  String slaskAut = "";
  String slaskTitl = "";

  String extension = "";
  String kontextString  =  "file:/amd/src/diglib/htdocs/bibliotek/";
  
  static int dokAnt, statusInt;
  static double dAnt = 1;
  
  public intext(String filnamn, KEF nytt)
    {
      try
	{
	  n = nytt;
	  infil = new File(filnamn);
	  b = new byte[(int) infil.length()];
	  infilStream = new FileInputStream(infil);
	  infilStream.read(b);
	  infilStream.close();
	}
      catch(FileNotFoundException e)
	{
	  System.out.println("Filen finns inte: "+e);
	}
      catch(IOException e)
	{
	  System.out.println("Filen gar ej att lasa: "+e);
	}
    }
  
  public intext(KEF nytt)
    {
      n = nytt;
      sokOmgang();
    }
  
  public void sokOmgang()
    {
      System.out.println("Inne i Sokomgang");
      
      int l,leng, i = 0;
      StringBuffer sb = new StringBuffer();
      DataInputStream dS;
      URL ur;
      Ref reff,r;
      
      n.closed = new Vector();
      
      try
	{
	  ur = new URL("http://www.sics.se/");
	  URL kontext = new URL(kontextString);

	  Enumeration enum = n.open.elements();
	  
	  // While there are more elements in the open vector
	  while(enum.hasMoreElements())
	    {
	      Ref tmp = (Ref)enum.nextElement();
	      n.Utemp = new URL(kontext,tmp.ref);

	      if(!ur.sameFile(n.Utemp))
		{
		  ur = n.Utemp;
		  n.Utemp.openConnection();
		  dS = new DataInputStream(n.inputS = (n.Utemp.openStream()));
		  String s = dS.readLine();
		  sb.append(s+" ");
		  while(s!=null)
		    {
		      sb.append(s+" ");
		      s = dS.readLine();
		    }
		  String st = sb.toString();
		  sb = null;
		  sb = new StringBuffer();
		  idRef = tmp.ref;
		  slaskAuth = tmp.aut;
		  slaskTitl = tmp.titel;
		  extension = sparaExtension(idRef);
		  n.closed.addElement(tmp);
		  htmlStrip(st);
		  dS.close();
		}
	    }
	}
      catch(MalformedURLException mE)
	{
	  System.out.println("Felaktig URL: "+mE);
	}
      catch(IOException e)
	{
	  System.out.println("FEL: "+e);
	}
    }
  
  public String lasIn()
    {
      String s = new String(b, 0);
      return s;
    }
  
  /////////////////////////////////////////////////////////////

  public String sparaExtension(String s)
    {
      String helaNamnet = s;
      String ext = "";
      StringTokenizer sT;
      
      sT = new StringTokenizer(helaNamnet, ".");
      sT.nextToken();
      ext = sT.nextToken();
      return ext;
    }

  public void adressLas(String str)
    {
      StringBuffer sB = new StringBuffer();
      String r = "";
      char c;
      StringCharacterIterator iter = 
	new StringCharacterIterator(str);

      c = iter.first();
    
      // Har blir strangarna i links.txt url:er
      // Dess bihangda titel och forfattare sparas undan
      // i slaskAut och slaskTitl

      // GOR EN STRING TOKENIZER!!!!
      // MEN FIXA OCKSA SPARAEXTENSION!!!!!!

      while(c!=CharacterIterator.DONE)
	{
	  // Om det ar reffen
	  // ...


	  if((Character.isSpaceChar(c))||(c == '\r')||(c == '\n')||
	     (c == '\f')||(c == '\b'))
	    {

	      // FIXA R, A, OCH T!!!!!!!!!
	      // # = ref
	      // @ = author
	      // & = titel

	      if(sB.length()>0)
		{
		  r = sB.toString();
		  Ref temp =  new Ref(r,a,t);
		  n.open.addElement(temp);
		  sB = new StringBuffer();
		  statusInt++;
		}
	      c = iter.next();
	    }
	  else
	    {
	      sB.append(c);
	      c = iter.next();
	    }
	}
    }

   /* 
      Metod som tar bort grundlaggande html-taggar
      dvs allt inom '<>', samt omvandlar &auml; mm till
      de korrekta svenska bokstaverna
   */
  public void htmlStrip(String ts)
    {
      System.out.println("");
      System.out.println("");
      System.out.println("*** Last fil. Stranglangd: "+ts.length());

      // om detta ar en textfil, ga direkt till hyphString
      if(extension.equals("txt"))
	{
	  hyphString(ts);
	}
      // annars ska htmltaggar bort
      else
	{
	  StringBuffer buffer = new StringBuffer();
	  StringBuffer sB = new StringBuffer();
	  buffer.ensureCapacity((ts.length()+5000));
	  
	  StringCharacterIterator iter = new StringCharacterIterator(ts);
	  char c[] = new char[1];
	  int currnt = 0;
	  char bokst;
	  
	  c[0] = iter.first();

	  while(c[0]!=CharacterIterator.DONE)
	    {
	      if(c[0] == '<') 
		{
		  while(c[0]!='>') c[0] = iter.next();
		  c[0] = iter.next();
		}
	      else if(c[0] == '&')
		{
		  currnt=iter.current();
		  c[0] = iter.next();
		  bokst = c[0];
		  if((bokst == 'a')||(bokst == 'A')||(bokst == 'o')||
		     (bokst == 'O')||(bokst == 'e')||(bokst == 'E')||
		     (bokst == 'u')||(bokst == 'U'))
		    {
		      c[0] = iter.next();
		      if(c[0]=='u')
			{
			  if(bokst == 'a') buffer.append('ä');
			  else if(bokst == 'A') buffer.append('Ä');
			  else if(bokst == 'o') buffer.append('ö');
			  else if(bokst == 'O') buffer.append('Ö');
			  else if(bokst == 'u') buffer.append('ü');
			  else if(bokst == 'U') buffer.append('Ü');
			  while(c[0]!=';') c[0]=iter.next();
			  c[0] = iter.next();
			}
		      else if(c[0] == 'a')
			{
			  if(bokst == 'e') buffer.append('é');
			  else if(bokst == 'E') buffer.append('É');
			  else if(bokst == 'a') buffer.append('á');
			  else if(bokst == 'A') buffer.append('Á');
			  while(c[0]!=';') c[0] = iter.next();
			  c[0] = iter.next();
			}
		      else if(c[0] == 'g')
			{
			  if(bokst == 'e') buffer.append('è');
			  else if(bokst == 'E') buffer.append('È');
			  else if(bokst == 'a') buffer.append('à');
			  else if(bokst == 'A') buffer.append('À');
			  while(c[0]!=';') c[0] = iter.next();
			  c[0] = iter.next();
			}
		      else if(c[0] == 'r')
			{
			  if(bokst=='a') buffer.append('å');
			  else if(bokst =='A') buffer.append('Å');
			  while(c[0]!=';') c[0] = iter.next();
			  c[0] = iter.next();
			}
		    }
		  else if(bokst=='#')
		    {
		      sB = new StringBuffer();
		      for(int y=0; y<4; y++)
			{
			  c[0] = iter.next();  
			  sB.append(c[0]);
			}
		      String str = new String(sB.toString());
		      if(str.equals("229;")) buffer.append('å');
		      else if(str.equals("228;")) buffer.append('ä');
		      else if(str.equals("196;")) buffer.append('Ä');
		      else if(str.equals("197;")) buffer.append('Å');
		      else if(str.equals("233;")) buffer.append('è');
		      c[0] = iter.next();
		    }
		  else
		    {
		      buffer.append(" 99");
		      c[0] = iter.next();
		    }	
		}
	      else if(c[0]==';')
		{
		  buffer.append(" ");
		  c[0] = iter.next();
		}
	      else 
		{
		  buffer.append(c[0]);
		  c[0] = iter.next();
		}
	    }
	  String s = new String(buffer.toString());
	  buffer = null;
	  hyphString(s);
	  s="";
	}
    }

  // Tar bort bindestreck, sa att swecg ska kunna lasa
  public void hyphString(String str)
    {
      System.out.println("i hyph"); 
      n.utdata.clear();
      n.utdata.addItem("Now processing document no "+(dokAnt+1)+" of "+statusInt);
      n.utdata.addItem("Please wait.");
      
      StringBuffer sB = new StringBuffer();
      String s = "";
      char ch;
      char c[] = new char[1];
      StringCharacterIterator iter = 
	new StringCharacterIterator(str);
      
      c[0] = iter.first();
      
      while(c[0]!=CharacterIterator.DONE)
	{
	  if(c[0] == '-')
	    {
	      c[0] = iter.next();
	      if(Character.isSpaceChar(c[0]))
		{
		  ch = iter.next();
		  if(Character.isLetter(ch))
		    {
		      sB.append(ch);
		      while(!Character.isLetter(c[0])) c[0] = iter.next();
		      sB.append(c[0]);
		      c[0] = iter.next();
		    }
		}
	      else if((Character.isLetter(c[0]))||
		      (Character.isDigit(c[0])))
		{
		  sB.append("-");
		  sB.append(c[0]);
		  c[0] = iter.next();
		}
	      else if((c[0] == '\n')||(c[0] == '\r')||(c[0] == '\t')||
		      (c[0] == '\f')||(c[0] == '\b'))
		{
		  c[0] = iter.next(); 
		  c[0] = iter.next();
		}
	    }
	  
	  // Lagger in newline efter kolon (for swecg:s skull)
	  else if(c[0] == ':') 
	    {
	      sB.append("\n");
	      //sB.append(c[0]+"\n");
	      //System.out.println(">>>>>>>>>>NEWLINE");
	      c[0] = iter.next();
	    }
	  
	  else 
	    {
	      sB.append(c[0]);
	      c[0] = iter.next();
	    }
	}
      s = sB.toString();
      skriv_till_fil(s);
    }
  
  
  public void skriv_till_fil(String s)
    {
      // Skriv ut strangen till fil, sa att swecg far tag i den
      try
	{
	  fil = new File("sweIn.txt");
	  filWri = new FileWriter(fil);
	  filWri.write(s+"\n");
	  filWri.write("\n");
	  filWri.close();
	  //System.out.println(s);
	}
      catch(IOException e)
	{
	  System.out.println("Filen går ej att skriva till: "+e);
	}
      // Anropar metod for att starta swecg    
      tillSwecg();
    }
  
  // Anropar swecg med textfilen (se ovan), utdatat skickas sedan vidare 
  // till ordLas()
  public void tillSwecg()
    {
      PrintStream proOut;
      InputStream  proIn;
      StringBuffer result;
      String s = "";
      
      try
	{
	  Process pro;
	  Runtime r;
	  
	  r  =  Runtime.getRuntime();
	  String list[] = {"/opt/swecg/bin/swecg","sweIn.txt"};
	  pro = r.exec(list);
	  
	  proIn = pro.getInputStream();
  
	  // inlasning av resultat fran utstrom
	  result  =  new StringBuffer(proIn.available());
	  int c = 0;
	  while(c!=-1){
	    c = proIn.read();
	    result.append((char)c);
	  }
	  /*
	  try { Thread.currentThread().sleep(20000); }
	  catch(InterruptedException ex){
	    System.out.println(">>>>>>>>>>>>>>>>>>FEL"+ex);
	  }
	  */
	  s  =  new String(result.toString());
	  //System.out.println(result);
	}
      catch(IOException je) {
	System.out.println("IOException: "+je); 
      }
      
      // Vidare bearbetning
      ordLas(s);
      //sorteraD();
      fil.delete();
    }  

  //////////////////////////////////////////////////////////

    // Denna ordLas jobbar enbart pa utdata fran swecg
    public void ordLas(String t)
    {
      char ab;
      StringBuffer sB = new StringBuffer();

      String str = "",ord = "";
      String A_ord = "",N_ord = "",N2 = "", NP_ord = "",AN_ord = "";
      char c[] = new char[1];
      StringCharacterIterator iter = new StringCharacterIterator(t);

      //System.out.println(t);

      Dokument doku;
      
     
      
      // Skapar ett nytt dokument
      // om det ar det forsta dokumentet
      if(Dvekt.size() == 0)
	{
	  doku = new Dokument(dokAnt);
	  Dvekt.addElement(doku);
	  doku.titel = idRef;
	}
      // om det redan finns dokument i dvektorn
      else
	{
	  dokAnt++;
	  dAnt++;
	  doku = new Dokument(dokAnt);
	  Dvekt.addElement(doku);
	  doku.titel = idRef;
	}

      System.out.println("dokumentobjektet skapat:"+(dokAnt+1));
      System.out.println("ID:"+doku.titel);

      c[0] = iter.first();
      while(c[0]!=CharacterIterator.DONE)
	{
	  if(c[0] == '\"')
	    {
	      c[0] = iter.next();
	      // Om raden inleds med " foljt av <, skippa raden
	      if(c[0] == '<') 
		{
		  //while(c[0]!='\"') c[0] = iter.next();
		  while(c[0]!='\n') c[0] = iter.next();
		}
	      // Om det daremot ar en bokstav (eller asterisk)...
	      // Spara undan ordet
	      else if((c[0] == '*')||(Character.isLetter(c[0])))
		{
		  if(c[0] == '*') 
		    {
		      c[0] = iter.next();
		      while(c[0]!='\"')
			{
			  if(c[0] == '*') c[0] = iter.next();
			  sB.append(c[0]);
			  c[0] = iter.next();
			}
		      ord = sB.toString();
		      sB = new StringBuffer();
		    }
		  else
		    {
		      while(c[0]!='\"')
			{
			  if(c[0] == '*') c[0] = iter.next();
			  sB.append(c[0]);
			  c[0] = iter.next();
			}
		      ord = sB.toString();
		      sB = new StringBuffer();
		    }
		  c[0] = iter.next();
		  c[0] = iter.next();
		  if (c[0]=='N')
		    {		
		      c[0] = iter.next();
		      if(Character.isSpaceChar(c[0]))      
			{
			  kapAnhalt(ord);
			}
		    }// end if 'N'
		  //***   Om <> efter ordet men fore N   ***
		  else if(c[0] == '<')
		    {
		      StringBuffer tempB = new StringBuffer();
		      while(c[0]!='>') 
			{
			  c[0] = iter.next();
			  tempB.append(c[0]);
			}
		      String s = new String(tempB.toString());
  
		      // Ur funktion
		      /* if(s.equals("NON-SWETWOL>"))
			{
			  //while(c[0]!='?') 
			  c[0] = iter.next();
			}
		      else
			{
		      */
			  /* om non-swetwol ga vidare raden ut
			     annars ga vidare med nedan:
			     (om man vill ta bort denna funktion, ta bort 
			     ovan if- samt else-satser
			  */
			  c[0] = iter.next();
			  c[0] = iter.next();

			  if(c[0]=='N')
			    {
			      c[0] = iter.next();
			      if(Character.isSpaceChar(c[0]))
				{
				  kapAnhalt(ord);
				}
			    }
			  //} // end non-swetwol else
		    } 
		}
	    }
	  c[0] = iter.next();
	}//end while not DONE
    }// end void ordLas
  
  void kapAnhalt(String st)
    {
      StringBuffer sB = new StringBuffer();
      StringBuffer buffer = new StringBuffer();
      StringCharacterIterator iter = 
	new StringCharacterIterator(st);
      char c[] = new char[1];
      char ch, k;
      String s ="";

      if(st.length()>0)
	{
	  c[0] = iter.first();
	  ch = c[0];
	  
	  // om det ar blanksteg i borjan av ordet
	  // ta bort det
	  if(st.startsWith(" "))
	     {
	       s = new String(st.substring(1,st.length()));
	     }
	  if(s.length()==0) s = st;

	  int xx = s.length();
	  int i,ii;
	  
	  // tar bort strangar som innehaller siffror, punkter, kolon och 
	  // komman mm (vanligt i scannat material)   
	  for(i = 0; i<xx; i++){
	    c[0] = iter.setIndex(i);
	    if((Character.isDigit(c[0]))||(c[0] == ',')||
	       (c[0] == '.')||(c[0] == ':')||(c[0] == '/')) return;
	  }
	  // Om strangen var ok
	  if(i == xx)
	    {
	      if(xx == 1) return;
	      else {
		// Drar ihop ord med '_' i
		iter = new StringCharacterIterator(s);
		for(i = 0; i<xx; i++){
		  c[0] = iter.setIndex(i);
		  if(c[0] == '_') c[0] = iter.next();
		  else sB.append(c[0]);
		}
		String stra = new String(sB.toString());
		dokVekt(stra);
		totalvekt(stra);
		buffer = new StringBuffer();
	      }
	    }
	}
      else return;
    }
  
  //***********************************************************
  
  public void dokVekt(String sd)
  {
    String nyttOrd = sd;
    Dokument dokpek = (Dokument)Dvekt.elementAt(dokAnt);
    Ord temp, temp2;
    
    // kontrollerar om ordet finns i dokumentets termvektor
    Enumeration enum  =  dokpek.dokumvekt.elements();
    while (enum.hasMoreElements())
      {
	temp = (Ord)enum.nextElement();
	if(temp.ord.equals(nyttOrd))
	  {
	    dokpek.tot++;
	    temp.dokfrekv++;
	    return;
	  }
      }
    temp2 = new Ord(nyttOrd);
    dokpek.tot++;
    temp2.dokfrekv++;
    dokpek.dokumvekt.addElement(temp2);
  }
  
  public void totalvekt(String str)
    {
      String nyttOrd = str;
      Ord ordTemp, otmp;
      urlObjekt utemp;

      // den stora vektorn med ordobjekt...
      Enumeration e  =  Total1.elements();
      while(e.hasMoreElements())
	{
	  ordTemp  =  (Ord)e.nextElement();
	  if(ordTemp.ord.equals(nyttOrd))
	    {
	      ordTemp.totOrdFrekv++;
	      // sedan kolla om current idRef finns i url-vektorn...
	      ordTemp.addToDocList(idRef, kontextString);
	      return;
	    }
	}
      otmp  =  new Ord(nyttOrd);
      otmp.totOrdFrekv++;
      Total1.addElement(otmp);
      otmp.addToDocList(idRef, kontextString);
    }


  // Sorterar den stora vektorn i frekvensordning
  public void sorteraTotal()
    {
      System.out.println("*");
      System.out.println("*");
      System.out.println("***** Sorterar Totalvektorn");
      System.out.println("totalStorlek i sortera: "+Total1.size()); 
      int lang = Total1.size(), g;
      
      while((g = (TotalVektor.size()))<lang)
	{
	  Ord tempA = (Ord)Total1.firstElement();
	  Enumeration enu = Total1.elements();
	 	    
	  while(enu.hasMoreElements())
	    {
	      Ord tempB = (Ord)enu.nextElement();
	      if(tempB.totOrdFrekv<tempA.totOrdFrekv)tempA = tempB;
	    }
	  TotalVektor.insertElementAt(tempA,0);
	  Total1.removeElement(tempA);
	}
      Total1 = null;
    }


  // Sorterar den stora vektorn i bokstavsordning
  public void sorteraAlfaBet()
    {
      System.out.println("*");
      System.out.println("*");
      System.out.println("***** Sorterar Totalvektorn");
      System.out.println("totalStorlek i sortera: "+Total1.size()); 
      int lang = Total1.size(), g;
      Ord small, large;
      
      while((g = (TotalVektor.size()))<lang)
	{
	  Ord tempA = (Ord)Total1.firstElement();
	  small = tempA;
	  large = tempA;
	  Enumeration enu = Total1.elements();
	 	    
	  while(enu.hasMoreElements())
	    {
	      Ord tempB = (Ord)enu.nextElement();
	      large = tempB;
	      int x = tempB.ord.compareTo(tempA.ord);
	      if(x>0)
		{ 
		  tempA = tempB;
		  small = tempA;
		}
	      else if (x<0)
		{
		  large = tempB;
		}
	    }
	  TotalVektor.insertElementAt(small,0);
	  //TotalVektor.insertElementAt(large,TotalVektor.size());
	  Total1.removeElement(tempA);
	}
      Total1 = null;
    }


  // tar bort ord, med endast en forekomst i ett dokument,
  // fran stora vektorn
  public void taBortEttor()
    {
      System.out.println("totalStorlek i tabort: "+Total1.size()); 
      Total2 = new Vector();
      Ord temp2;
      Enumeration enu = Total1.elements();
      while(enu.hasMoreElements())
	{
	  Ord temp = (Ord)enu.nextElement();
	  if((temp.totOrdFrekv<2) & (temp.jagFinnsIsaManga<2)) 
	    {
	      temp2 = temp; 
	    }
	  else
	    {
	      Total2.insertElementAt(temp,0);
	    }
	}
      Total1 = new Vector();
      Total1 = Total2;
      Total2 = null;
    }
  

  // Sorterar de enskilda dokumeneten i frekvensordning
  public void sorteraD()
    {
      System.out.println(">>>>>>>>I sortera D");
      Dokument dk;
      
      dk = (Dokument)Dvekt.elementAt(dokAnt);
      int lang = dk.dokumvekt.size(), g;
      while((g = (dk.sortvekt.size()))<lang)
	{
	  Ord tempA = (Ord)dk.dokumvekt.firstElement();
	  Enumeration enu = dk.dokumvekt.elements();
	  while(enu.hasMoreElements())
	    {
	      Ord tempB = (Ord)enu.nextElement();
	      if(tempB.dokfrekv<tempA.dokfrekv)tempA = tempB;
	    }
	  dk.sortvekt.insertElementAt(tempA,0);
	  dk.dokumvekt.removeElement(tempA);
	}
      dk.dokumvekt = null;
    }
  
  public void skrivTillUtfil()
    {
      try
	{
	filWri = new FileWriter("uttext.txt");

	filWri.write("Antal dokument: "+(dokAnt+1)+"\n\n");
	filWri.write("Ord\t\t\t\t\t");
	filWri.write("Totalt antal\t");
	filWri.write("Antal dok\n");
		
	Enumeration enum = TotalVektor.elements();
	while(enum.hasMoreElements())
	  {
	    Ord temp = (Ord)enum.nextElement();
	    filWri.write(temp.ord+"\t\t\t\t\t");
	    filWri.write(temp.totOrdFrekv+"\t\t");
	    filWri.write(temp.jagFinnsIsaManga+"\n");
	  }
	filWri.close();
	}
      catch(IOException e)
	{
	  System.out.println("Filen gar ej att skriva till: "+e);
	}
    }

  public void skrivUtDokumentVektor()
    {
      try
	{
	  filWri = new FileWriter("dokument.txt");
	  
	  filWri.write("Antal dokument: "+(dokAnt+1)+"\n\n");
	  
	  Enumeration enum = Dvekt.elements();
	  while(enum.hasMoreElements())
	    {
	      Dokument dtemp = (Dokument)enum.nextElement();
	      filWri.write("\n\n");
	      filWri.write("Ny fil inlast: "+dtemp.titel+"\n\n");
	      filWri.write("Ord\t\t\t\t\t");
	      filWri.write("Antal i dok\n");
	      
	      Enumeration e = dtemp.sortvekt.elements();
	      while(e.hasMoreElements())
		{
		  Ord otemp = (Ord)e.nextElement();
		  filWri.write(otemp.ord+"\t\t\t\t\t");
		  filWri.write(otemp.dokfrekv+"\n");
		}
	    }
	  filWri.close();
	}
      catch(IOException e)
	{
	  System.out.println("Dokumentfil kaputt. IOExcept: "+e);
	}
      skrivUtAllt();

      System.out.println("*");
      System.out.println("*");
      System.out.println("*");
      System.out.println("*** klar ***");
      System.out.println("*");
      System.out.println("*");
      System.out.println("*");
    }  

  public void skrivUtAllt()
    {
      try
	{
	  File fil = new File("kefUT.txt");
	  filWri = new FileWriter(fil);
	  
	  Enumeration enum = TotalVektor.elements();
	  while(enum.hasMoreElements())
	    {
	      Ord temp = (Ord)enum.nextElement();
	      filWri.write(temp.ord+"\n");
	      Enumeration e = temp.allaDokument.elements();
	      while(e.hasMoreElements())
		{
		  urlObjekt utemp = (urlObjekt)e.nextElement();
		  filWri.write(utemp.id+"\n\n");
		}
	    }
	  filWri.close();
	}
      catch(IOException e)
	{
	  System.out.println("AlltUTfil kaputt. IOExcept: "+e);
	}
    }  

  public void utData()
    {
      n.utdata.clear();
                  
      n.utdata.addItem("Antal dokument: "+(dokAnt+1));

      n.indata.append("Done!");

      Enumeration enum = TotalVektor.elements();
      while(enum.hasMoreElements())
	{
	  Ord temp = (Ord)enum.nextElement();
	  n.utdata.addItem(temp.ord+" ("+temp.totOrdFrekv+"/"+temp.jagFinnsIsaManga+")");
	}
    }
}

//Slut på class intext

class Ord
{
  String ord;
  int dokfrekv,totOrdFrekv;
  int jagFinnsIsaManga;
  boolean nyttDok;
  Vector allaDokument  =  new Vector();
  
  public Ord(String st)
  {
    ord = st;
    nyttDok = true;
  }

  public void addToDocList(String id, String kontx)
    {
      urlObjekt temp;
      String str  =  id;

      Enumeration enum  =  allaDokument.elements();
      
      while(enum.hasMoreElements())
	{
	  temp = (urlObjekt)enum.nextElement();
	  /* om id:et redan finns, dvs dokumentet redan bidragit med 
	     detta ord, rakna upp antalet i urlobjektet.
	  */
	  if(temp.id.equals(str))
	    {
	      /* leta upp id:et (dvs ratt objekt)
		 Uppdatera dess frekvens... Hur Manga ggr i detta dok
	      */
	      temp.minDokfrekvens  =  dokfrekv;
	      return;
	    }
	}
      
      // om det ar forsta gg detta ord forekommer i dokumentet
      urlObjekt uO  =  new urlObjekt(str);
      allaDokument.addElement(uO);
      jagFinnsIsaManga++;
    }
}
//Slut class Ord

class urlObjekt
{
  int minDokfrekvens;
  String id  =  "";
  String author = "";
  String titel = "";

  public urlObjekt(String u)
    {
      id  =  u;      
    }
}

class Dokument
{
  String titel  =  "", url  =  "";
  int id, dokunik, tot, god;
  
  Vector dokumvekt;
  Vector sortvekt;
  
  public Dokument(int i)
  {
    dokumvekt = new Vector();
    sortvekt = new Vector();
    dokunik = 0;
    tot = 0;
    id = i;
  }
}
//Slut class Dokument

class Ref
{
  URL ur;
  String ref = "";
  String aut = "";
  String titel = "";
  
  public Ref(String r, String a, String t)
  {
    ref = r;
    aut = a;
    titel = t;
  }
}







