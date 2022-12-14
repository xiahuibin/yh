(function($) {
  var menuOpts = {
    data: [],
    items: [],
    el: null,
    icon: false,
    activeMenu: 0,
    openUrl: $.noop,
    expandType: 0,
    isLazyLoad: false,
    lazyLoadData: $.noop,
    animate: true,
    classes: [],
    liClass: [],
    selClass: '',
    expClass: []
  };
  
  YH.createComponent("Menu", menuOpts, YH.Component.prototype, {
    initComponent: function() {
      this.items = this.data;
      this.createUL(this.items, 0, this.el);
    },
    /**
     * 创建UL,并初始化A标签的点击事件     * @param lv            目录的等级     * @param container     目录的容器     */
    createUL: function(items, lv, container) {
      var ul = $('<ul></ul>');
      var self = this;
      container.append(ul);
      if (this.classes[lv]) {
        ul.attr('class', this.classes[lv]);
      }
      
      $.each(items, function(i, e) {
        var a = $('<a href="javascript:void(0)"></a>');
        var li = $('<li></li>').append(a);
        
        //在li中记录id信息,暂时为快捷菜单的排序服务
        li.data('id', e.id);
        e.li = li;
        ul.append(li);
        
        self.addMethod(e);
        
        if (!e.leaf) {
          li.attr('class', self.liClass[lv]);
          if (!self.isLazyLoad && e.children) {
            var temp = $('<li style="height:auto;display:none;"></li>');
            li.after(temp);
            self.createUL.call(self, e.children, lv + 1, temp);
          }
        }
        if (e.icon && self.icon) {
          var img = $('<img></img>');
          img.attr('src', e.icon);
          a.append(img);
        }
        
        var span = $('<span></span>').html(e.text);
        a.append(span);
        
        //处理默认展开菜单
        if (e.id == self.activeMenu || e.active) {
          self.menuClick(e, lv, li, false);
        }
        
        a[0].onclick = function() {
          self.menuClick(e, lv, li);
          return false;
        };
      });
    },
    /**
     * 为每个菜单项添加方法
     */
    addMethod: function(e) {
      e.show = function() {
        e.li.show();
      }
      e.hide = function() {
        e.li.hide();
      }
      e.setText = function(text) {
        e.text = text;
        a.html(text);
      }
    },
    /**
     * 菜单点击事件
     * @param menu              菜单节点
     * @param lv                菜单节点的级次     * @param li                菜单节点对应的LI标签
     * @param animate           点击菜单是否需要动画效果
     */
    menuClick: function(menu, lv, li, animate) {
      if (animate == undefined) {
        animate = this.animate;
      }
      if (menu.handleClick) {
        menu.handleClick(menu, this);
      }
      else if (!!menu.leaf) {
        this.solveLastClick(li);
        this.openUrl(menu, this);
      }
      else{
        if (this.isLazyLoad){
          if (!li.data('expend')){
            li.data('expend', true);
            if (!li.data('opened')) {
              var data = this.lazyLoadData(menu, this);
              li.after('<li style="height:auto;display:none;"></li>');
              var container = li.next();
              this.createUL(data, lv + 1, container);
              container.show(animate ? this.speed || 500 : 0);
              li.data('opened', true);
            }
            else {
              li.next().show(animate ? this.speed || 500 : 0);
            }
            this.solveLastExpand(li, lv);
          }
          else {
            li.next().hide(this.speed || 500);
            li.removeClass(this.expClass[lv]);
            li.data('expend', false);
          }
        }
        else {
          if (!li.data('expend')){
            li.data('expend', true);
            li.next().show(animate ? this.speed || 500 : 0);
            this.solveLastExpand(li, lv);
          }
          else {
            li.next().hide(this.speed || 500);
            li.removeClass(this.expClass[lv]);
            li.data('expend', false);
          }
        }
      }
    },
    solveLastClick: function (li) {
      if (this.lastClick) {
        this.lastClick.removeClass(this.selClass);
      }
      this.lastClick = li;
      li.addClass(this.selClass);
    },
    solveLastExpand: function (li, lv) {
      if (!this.lastExpand) {
        this.lastExpand = [null, null, null];
      }
      li.addClass(this.expClass[lv]);
      if (!this.expandType){
        if (this.lastExpand[lv] && this.lastExpand[lv] != li) {
          this.lastExpand[lv].removeClass(this.expClass[lv])
          this.lastExpand[lv].next().hide(this.speed || 500);
          this.lastExpand[lv].data('expend', false)
        }
        this.lastExpand[lv] = li;
      }
    },
    /**
     * 用户自定义函数,点击的事件
     * @param node             对应的目录节点
     * @param self                YH.Menu的实例引用
     */
    openUrl: $.noop
  });
})(jQuery);