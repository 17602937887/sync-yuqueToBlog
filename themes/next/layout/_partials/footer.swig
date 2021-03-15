<script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.footer.icon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>

  {% if theme.post_wordcount.totalcount %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.post_wordcount.item_text %}
      <span class="post-meta-item-text">{{ __('post.totalcount') }}&#58;</span>
    {% endif %}
    <span title="{{ __('post.totalcount') }}">{#
    #}{{ totalcount(site, '0,0.0a') }}{#
  #}</span>
  {% endif %}
</div>

<div class=BbeiAn-info">
  {{ __('陕ICP备') }} -
  <a href="http://www.beian.gov.cn/portal/registerSystemInfo?spm=5176.13841030.7y9jhqsfz.114.379a5c69PrmQbd">
16019742号-2</a>
  </a>
</div>

{% if theme.footer.custom_text %}
  <div class="footer-custom">{#
  #}{{ theme.footer.custom_text }}{#
#}</div>
{% endif %}

 <script>
      var now = new Date(); 
      function createtime() { 
          var grt= new Date("09/22/2018 12:00:00");//此处修改你的建站时间或者网站上线时间 
          now.setTime(now.getTime()+250); 
          days = (now - grt ) / 1000 / 60 / 60 / 24; dnum = Math.floor(days); 
          hours = (now - grt ) / 1000 / 60 / 60 - (24 * dnum); hnum = Math.floor(hours); 
          if(String(hnum).length ==1 ){hnum = "0" + hnum;} minutes = (now - grt ) / 1000 /60 - (24 * 60 * dnum) - (60 * hnum); 
          mnum = Math.floor(minutes); if(String(mnum).length ==1 ){mnum = "0" + mnum;} 
          seconds = (now - grt ) / 1000 - (24 * 60 * 60 * dnum) - (60 * 60 * hnum) - (60 * mnum); 
          snum = Math.round(seconds); if(String(snum).length ==1 ){snum = "0" + snum;} 
          document.getElementById("timeDate").innerHTML = "本站已安全运行 "+dnum+" 天 "; 
          document.getElementById("times").innerHTML = hnum + " 小时 " + mnum + " 分 " + snum + " 秒"; 
      } 
  setInterval("createtime()",250);
  </script>
