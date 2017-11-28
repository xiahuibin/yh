/** �������� **/
var KEY_TAB = 0X0009;        //9
var KEY_ENTER = 0X000D;      //13
var KEY_ESC = 0X001B;        //27
var KEY_PAGE_UP = 0X0021;    //33
var KEY_PAGE_DOWN = 0X0022;  //34
var KEY_PAGE_END = 0X0023;   //35
var KEY_PAGE_HOME = 0X0024;  //36
var KEY_LEFT = 0X00025;      //37
var KEY_UP = 0X0026;         //38
var KEY_RIGHT = 0X0027;      //39
var KEY_DOWN = 0X0028;       //40
var KEY_INS = 0X002D;        //45
var KEY_DEL = 0X002E;        //46
var KEY_A = 0X0041           //65
var KEY_B = 0X0042           //66
var KEY_C = 0X0043           //67
var KEY_D = 0X0044           //68
var KEY_E = 0X0045           //69
var KEY_F = 0X0046           //70
var KEY_G = 0X0047           //71
var KEY_H = 0X0048           //72
var KEY_I = 0X0049           //73
var KEY_J = 0X004A           //74
var KEY_K = 0X004B           //75
var KEY_L = 0X004C           //76
var KEY_M = 0X004D           //77
var KEY_N = 0X004E           //78
var KEY_O = 0X004F           //79
var KEY_P = 0X0050           //80
var KEY_Q = 0X0051           //81
var KEY_R = 0X0052           //82
var KEY_S = 0X0053           //83
var KEY_T = 0X0054           //84
var KEY_U = 0X0055           //85
var KEY_V = 0X0056           //86
var KEY_W = 0X0057           //87
var KEY_X = 0X0058           //88
var KEY_Y = 0X0059           //89
var KEY_Z = 0X005A           //90
var KEY_F1 = 0X0070          //112
var KEY_F2 = 0X0071          //113
var KEY_F3 = 0X0072          //114
var KEY_F4 = 0X0073          //115
var KEY_F5 = 0X0074          //116
var KEY_F6 = 0X0075          //117
var KEY_F7 = 0X0076          //118
var KEY_F8 = 0X0077          //119
var KEY_F9 = 0X0078          //120
var KEY_F10 = 0X0079         //121
var KEY_F11 = 0X007A         //122
var KEY_F12 = 0X007B         //123

/**
 * �����¼��ڵ���
 * @author                     YZQ
 * @date                       2006-09-28
 * @cntrlName                  �ؼ�����
 * @handleNodeEvent            ��������¼�����
 */
function KeyNode(cntrlName, handleNodeEvent) {
  this.cntrlName = cntrlName;
  this.handleNodeEvent = handleNodeEvent;
}
/**
 * �����¼�ӳ���
 * @author                     YZQ
 * @date                       2006-09-28
 */
function KeyMap() {
  /**
   * �ؼ������б�
   */
  this.keyNodeMap = new ArrayHashMap();
  /**
   * ӳ�����ļ����¼�����   
   */
  this.handleMapEvent = null;
  
  /**
   * �Ƿ�����ÿؼ�
   * @cntrlName        �ؼ�����
   */
  this.contains = function(cntrlName) {
    return this.keyNodeMap.containsKey(cntrlName);
  }
 
  /**
   * ���ӿؼ�
   * @cntrlName     �ؼ�����   
   */
  this.addCntrl = function(keyNode) {
    if (typeof keyNode == "string") {
      var cntrlArray = keyNode.split(",");
      for (var i = 0; i < cntrlArray.length; i++) {
        var cntrlName = trim(cntrlArray[i]);
        this.keyNodeMap.put(cntrlName, new KeyNode(cntrlName, null));
      }
    }else {
      this.keyNodeMap.put(keyNode.cntrlName, keyNode);
    }
  }
  
  /**
   * ����ؼ�
   */
  this.clear = function() {
    this.keyNodeMap.clear();
  }
  
  /**
   * ������ȡ���¼��ڵ�
   * @index
   */
  this.getKeyNodeByIndex = function(index) {
    return this.keyNodeMap.getValue(index);
  }
  
  /**
   * ������ȡ�ÿؼ�����
   * @index
   */
  this.getCntrlNameByIndex = function(index) {
    return this.getKeyNodeByIndex(index).cntrlName;
  }
  
  /**
   * ������ȡ�ÿؼ�
   * @index
   */
  this.getCntrlByIndex = function(index) {
    return document.getElementById(this.getCntrlNameByIndex(index));
  }
  
  /**
   * ȡ����һ���ؼ�
   * @cntrlName     �ؼ�����
   */   
  this.nextKeyNode = function(cntrlName) {
    var keyNodeIndex = this.keyNodeMap.keyIndexOf(cntrlName);
    if (keyNodeIndex < 0) {
      return null;
    }
    var nextNodeIndex = (keyNodeIndex + 1) % this.keyNodeMap.size();
    
    return this.getKeyNodeByIndex(nextNodeIndex);    
  }
    
  /**
   * ��������¼�
   */
  this.handleKeyEvent = function() {
    var cntrl = event.srcElement;
    var cntrlName = cntrl.name ? cntrl.name : cntrl.id;
    var keyNode = this.keyNodeMap.get(cntrlName);
    if (!keyNode) {
      return;
    }
    
    if (keyNode.handleNodeEvent) {
      keyNode.handleNodeEvent(cntrlName);
    }else if (this.handleMapEvent) {
      this.handleMapEvent(cntrlName);
    }else {
      this.selectNextCntrl(cntrlName);
    }
  }
  
  /**
   * ʹ�ؼ�ȡ�ý���
   * @ctnrlId      �ؼ�������/ID/����
   */
  this.focus = function(ctnrlId) {    
    if (!ctnrlId) {
      ctnrlId = 0;
    }
    if (typeof ctnrlId == "string") {
      ctnrlId = this.keyNodeMap.keyIndexOf(ctnrlId);
    }
    var cntrl = this.getCntrlByIndex(ctnrlId);
    if (cntrl) {
      cntrl.focus();
    }
  }
  
  /**
   * ʹ�ؼ�ѡ��
   * @ctnrlId      �ؼ�������/ID/����
   */
  this.select = function(ctnrlId) {
    if (ctnrlId == null) {
      ctnrlId = 0;
    }
    if (typeof ctnrlId == "string") {
      ctnrlId = this.keyNodeMap.keyIndexOf(ctnrlId);
    }
    var cntrl = this.getCntrlByIndex(ctnrlId);
    if (cntrl) {
      cntrl.focus();
      if (cntrl.select && cntrl.value) {
        cntrl.select();
      }
    }
  }
  
  /**
   * ѡ����һ���ؼ�
   * @cntrlName          ��ǰ�ؼ�����
   */
  this.selectNextCntrl = function(cntrlName) {
    var nextKeyNode = this.nextKeyNode(cntrlName);
	  if (!nextKeyNode) {
	    return;
	  }
	  var cntrlName = nextKeyNode.cntrlName;
	  
	  var cntrl = document.getElementById(cntrlName);
	  var cnt = 0;
	  while (true) {
	    cnt++;
	    //ѭ��������ϣ��û�ҵ���������ѭ��
	    if (cnt >= this.keyNodeMap.size()) {
	      break;
	    }
	    if (!cntrl) {
	      break;
	    }
	    if (cntrl.readOnly || cntrl.disabled || cntrl.style.display == "none" || cntrl.type.toLowerCase() == "hidden") {
	      nextKeyNode = this.nextKeyNode(cntrlName);
	      if (!nextKeyNode) {
			    break;
			  }
			  cntrlName = nextKeyNode.cntrlName;			  
			  cntrl = document.getElementById(cntrlName);
	    }else {
	      cntrl.focus();
			  if (cntrl.value) {
			    cntrl.select();
			  }
			  break;
	    }
	  }
  }
}

/**
 * ��״̬���壬��Ϊ�¼���Ӧ�ļ�ֵ
 */
function KeyState(keyCode, isCtrl, isShift, isAlt) {
  this.keyCode = keyCode;
  this.isCtrl = isCtrl;
  this.isShift = isShift;
  this.isAlt = isAlt;
  
  /**
   * ת��Ϊ�ַ���
   */
  this.toString = function() {
    return "" + this.keyCode
      + "-" + (this.isCtrl ? "1" : "0")
      + "-" + (this.isShift ? "1" : "0")
      + "-" + (this.isAlt ? "1" : "0");
  }
}

/**
 * �����¼�������
 */
function KeyEventManager() {
  //Cntrl�Ƿ������
  this.isCtrl = null;
  //Shift�Ƿ������
  this.isShift = null;
  //Alt���Ƿ���
  this.isAlt = null;
  //��ǰ���¼��ı���
  this.keyCode = null;
  
  //�����¼���Ӧע���ϣ��
  this.keyEventMap = new ArrayHashMap();
  
  /**
   * �۽��ؼ�
   * @cntrlName          �ؼ�����/ID/����
   */
  this.focus = function(cntrlName) {
    if (!cntrlName) {
      cntrlName = 0;
    }
    var keyCnt = this.keyEventMap.size();
    for (var i = 0; i < keyCnt; i++) {
      var handler = this.keyEventMap.getValue(i);
      if (handler instanceof KeyMap) {
        if (handler.contains(cntrlName)) {
          handler.focus(cntrlName);
          break;
        }
      }
    }
  }
  
  /**
   * ѡ��ؼ�
   * @cntrlName          �ؼ�����/ID/����
   */
  this.select = function(cntrlName) {
    if (!cntrlName) {
      cntrlName = 0;
    }
    var keyCnt = this.keyEventMap.size();
    for (var i = 0; i < keyCnt; i++) {
      var handler = this.keyEventMap.getValue(i);
      if (handler instanceof KeyMap) {
        if (handler.contains(cntrlName)) {
          handler.select(cntrlName);
          break;
        }
      }
    }
  }
  
  /**
   * ע������¼������ϣ��
   * @keyState         ����״̬����
   * @map              �����¼�����
   */
  this.addKeyEventHandler = function(keyState, handler, cntrlName) {
    if (typeof keyState == "number") {
      keyState = "" + keyState;
    }
    if (typeof handler == "string") {
      var cntrls = handler;      
	    handler = new KeyMap();
	    handler.addCntrl(cntrls);
    }
    if (cntrlName) {
      var cntrlHandler = handler;
	    handler = new KeyMap();
	    handler.addCntrl(new KeyNode(cntrlName, cntrlHandler));
    }  
    if (typeof keyState == "string") {
      var keyCodeArray = keyState.split(",");
      for (var i = 0; i < keyCodeArray.length; i++) {
        var keyCode = keyCodeArray[i];
        this.keyEventMap.put(new KeyState(keyCode).toString(), handler);
      }
    }else {
      this.keyEventMap.put(keyState.toString(), handler);
    }
  }  
  /**
   * ɾ��ע��
   */
  this.removeKeyEvent = function(keyState) {
    this.keyEventMap.remove(keyState.toString());
  }  
  /**
   * ȡ���¼���Ӧ
   */
  this.getKeyEventMap = function(keyState) {
    return this.keyEventMap.get(keyState.toString());
  }
  
  /**
   * Ĭ�ϼ����¼�������-���̰���
   */
  this.handleKeydown = function() {
    //���ÿ��Ƽ�״̬����
	  this.isCtrl = event.ctrlKey;
	  this.isShift = event.shiftKey;
	  this.isAlt = event.altKey;
	  this.keyCode = event.keyCode;
	  
	  if (this.keyCode == KEY_TAB) {
	    var currKeyState = new KeyState(this.keyCode,
        this.isCtrl, this.isShift, this.isAlt);
      var handler = this.getKeyEventMap(currKeyState);
      if (handler) {
        event.returnValue = false;
      }
	  }
  }
  /**
   * Ĭ�ϼ����¼�������-���̵���
   */
  this.handleKeyup = function() {
    if (!this.keyCode) {
      //���ÿ��Ƽ�״̬����
		  this.isCtrl = false;
		  this.isShift = false;
		  this.isAlt = false;
      return;
    }  
    var currKeyState = new KeyState(this.keyCode,
        this.isCtrl, this.isShift, this.isAlt);
    //alert(this.keyCode + ">>" + currKeyState.toString());
    var handler = this.getKeyEventMap(currKeyState);

    if (handler && handler["handleKeyEvent"]) {
      handler.handleKeyEvent();
    }else if (handler) {
      try {
        handler();
      }catch(exception) {
        alert(exception.description);
      }
    }
       
    //���ÿ��Ƽ�״̬����
	  this.isCtrl = false;
	  this.isShift = false;
	  this.isAlt = false;
	  this.keyCode = null;
  }
  /**
   * Ĭ�ϼ����¼�������-����
   */
  this.handleKeypress = function() {
    alert("keypress");
  }
  
  /**
   * ������̵���
   */
  this.activeKeyNevgator = function() {    
    this.registKeyDown();
    this.registKeyUp();
  }
  
  /**
   * ע������¼�������Ӧ����
   * @eventSrc              �¼�Դ�����û�д�������Ϊ��document
   * @eventHandler          ���û��
   */
  this.registKeyDown = function(eventSrc, eventHandler) {
    this.registKeyEventHandler("onkeydown", eventSrc, eventHandler)
  }
  
  /**
   * ע������¼�������Ӧ����
   * @eventSrc              �¼�Դ�����û�д�������Ϊ��document
   * @eventHandler          ���û��
   */
  this.registKeyUp = function(eventSrc, eventHandler) {
    this.registKeyEventHandler("onkeyup", eventSrc, eventHandler)
  }
  
  /**
   * ע������¼���Ӧ����
   * @eventName             �¼����ƣ����봫�ݣ�onkeydown/onkeypress/onkeyup
   * @eventSrc              �¼�Դ�����û�д�������Ϊ��document
   * @eventHandler          ���û��
   */
  this.registKeyEventHandler = function(eventName, eventSrc, eventHandler) {
    if (!eventName) {
      alert(lm("jsp.js.common.keyevent.needKeyEventName"));
      return;
    }
    if (!eventSrc) {
      eventSrc = document;
    }
    if (!eventHandler) {
      var handleName = "handle";
      var firstChar = eventName.substring(2, 3);
      handleName += firstChar.toUpperCase() + eventName.substring(3, eventName.length);
      eventHandler = this[handleName];
    }
    
    eventSrc[eventName] = eventHandler.bind(this);
  }
}

function handleKeyEventDefault() {
  var cntrl = event.srcElement;
  var keyCode = event.keyCode;
  
  if (cntrl.tagName.toLowerCase() != "input" && 
      cntrl.tagName.toLowerCase() != "select") {
    return;
  }
  var currTd = cntrl.parentElement;
  var cntrl = null;
  if (keyCode == KEY_ENTER || keyCode == KEY_RIGHT) {
    cntrl = findNext(this, currTd, "r");
  }else if (keyCode == KEY_LEFT) {
    cntrl = findNext(this, currTd, "l");
  }else if (keyCode == KEY_UP) {
    cntrl = findNext(this, currTd, "u");
  }else if (keyCode == KEY_DOWN) {
    cntrl = findNext(this, currTd, "d");
  }
  if (cntrl) {
    try {
      selectLast(cntrl);
    }catch(e) {
      cntrl.focus();
    }
		stopEventBuble();
  }
}

/**
 * ������һ���ؼ�
 */
function findNext(tableObj, td, direct) {
  var tr = td.parentElement;
  var currTr = null;

  var srcRowIndex = tr.rowIndex;
  var srcColIndex = td.cellIndex;
  var destRowIndex = -1;
  var destColIndex = -1;

  var rowCnt = tableObj.rows.length;
  var columCnt = tableObj.rows[0].cells.length;

  var lineIndex = srcRowIndex * columCnt + srcColIndex;
  
  if (direct == "r") {
	  lineIndex++;	
	  destRowIndex = lineIndex / columCnt;
	  destColIndex = lineIndex % columCnt;
  }else if (direct == "l") {
    lineIndex--;	
	  destRowIndex = lineIndex / columCnt;
	  destColIndex = lineIndex % columCnt;
  }else if (direct == "d") {
    destRowIndex = srcRowIndex + 1;
    destColIndex = srcColIndex;
  }else if (direct == "u") {
    destRowIndex = srcRowIndex - 1;
    destColIndex = srcColIndex;
  }
  if (destRowIndex >= rowCnt || destRowIndex < 1) {
    return null;
  }
  var destTd = null;
  try {
    currTr = tableObj.rows[destRowIndex];
    destTd = currTr.cells[destColIndex];
  }catch(e) {
    return null;
  }
  //����������
  var colArray = tableObj.getElementsByTagName("COL");
  if (destTd.style.display == "none") {
    return findNext(tableObj, destTd, direct);
  }else if (colArray) {
    var colObj = null;
    var cellIndex = 0;
    for (var i = 0; i < colArray.length; i++) {
      colObj = colArray[i];
      var span = colObj.span ? colObj.span : 1;
      if ((cellIndex + span) > destTd.cellIndex) {
        break;
      }
      cellIndex += span;
    }
    if (colObj.style.display == "none") {
      return findNext(tableObj, destTd, direct);
    }
  }
  var inputCntrls = destTd.getElementsByTagName("INPUT");
  if (!inputCntrls || inputCntrls.length < 1) {
    inputCntrls = destTd.getElementsByTagName("SELECT");
  }
  if (inputCntrls && inputCntrls.length > 0) {
    for (var i = 0, cnt = inputCntrls.length; i < cnt; i++) {
      var cntrl = inputCntrls[i];
      if (cntrl.tagName.toLowerCase() == "select" && !cntrl.disabled && cntrl.style.display != "none") {
        if (cntrl.style.visibility == "hidden") {
          cntrl.style.visibility = "visible";
        }
        setPointer(currTr, "select");
        return cntrl;
      }
      if (cntrl.tagName.toLowerCase() == "input") {
        if (cntrl.type == "text" && !cntrl.disabled && !cntrl.readOnly && cntrl.style.display != "none") {
          if (cntrl.style.visibility == "hidden") {
	          cntrl.style.visibility = "visible";
	        }
	        setPointer(currTr, "select");
          return cntrl;
        }
      }
    }
    return findNext(tableObj, destTd, direct);
  }else {
    return findNext(tableObj, destTd, direct);
  }
}