			SELECT                                                               --id=${v.distStoreId}&distId=${v.corprationId}"
            a.STOREID factStoreId --厂家店铺id
            ,a.COORPRATIONID  factId --厂家企业id
            ,c.FACBRANDID brandId--品牌id
            ,d.STOREID distStoreId --经销商店铺id
            ,d.STORENAME distStoreName --经销商店铺名称
            ,d.COORPRATIONID corprationId --经销商企业id
            ,e.linkMan distName --联系人
            ,e.MOBILEPHONE distTelephone --联系电话
            ,(SELECT count(1) FROM store.T_STORE m1 LEFT JOIN goods.t_goods_sku m2 ON m1.storeid = m2.STOREID
            inner join (select GOODSSKUID, MAX(SnapshotNO) SnapshotNO from goods.T_GOODS_SKU GROUP BY GOODSSKUID) maxsku
                on m2.GOODSSKUID = maxsku.GOODSSKUID and m2.SnapshotNO = maxsku.SnapshotNO
            INNER JOIN store.T_Store_AuthrizedGoods m3 ON m2.goodsskuid = m3.skugoodsid WHERE userid = d.COORPRATIONID and m2.brandid = c.FACBRANDID) distGoodsCount-- 经销商代理此厂家商品总数
            ,d.STORESCORE distStoreScore--经销商店铺评分
            ,auth.channelopestatus distStoreStatus--经销商店铺审核状态
            ,e.CITYAREAID CITYID
            ,f.enterpriseName DISTSTATION --经销商服务站名称
            --,f.DISTRICTAREAID areaId--所在地区
            --,f.ProvinceAreaID provinceId--所在省id
            --,f.CityAreaID cityId  --所在市
            ,d.storeType --店铺类型
            ,bill.id billId --结算id
            ,rel.billcycle --结账周期
            ,bill.billname --结算方式
            ,c.enterid  --入驻id
            ,c.createtime
            FROM store.T_STORE a --厂家店铺
            inner JOIN store.T_Store_RecruitMerchantEnter c ON c.facbrandid = a.brandid
            AND c.PROCESSSTATUS = 2 AND c.APPROVALSTATUS = 0 AND c.DELETIONSTATUS = 0 --厂家招商所有有效经销商
            inner JOIN store.t_store d ON c.STOREID = d.STOREID  AND d.STORESTATUS = 0 --AND d.SIGNSTATUS = 0 AND d.APPROVALSTATUS = 0 --经销商店铺详情
            left JOIN users.T_USER_CORPORATEUSER e ON d.COORPRATIONID = e.USERID -- 经销商企业详情
            left JOIN users.T_USER_CORPORATEUSER f ON d.ServiceStationID = f.USERID --经销商服务站详情
            -- 厂家授权经销商店铺表
          left join Store.T_Store_AuthrizedOperation
          auth on
          auth.FactoryStoreID=a.Storeid and auth.StoreID=d.StoreID
          left join store.t_store_recruit_billing_rel rel on c.enterid = rel.inviteorapplyid and rel.isclosed = 0
             left join store.t_store_recruit_billing bill on bill.id = rel.billid and bill.deletionstatus = 0
            WHERE a.APPROVALSTATUS = 0
            
   --          select * from goods.T_Goods_CategoryRel
   
   
   
         <if test="categoryType != null and categoryType == 1">
            <choose>
            <when test="category3 != null and category3 != ''">
              <![CDATA[AND cate.CATEGORYID = #{category3}]]>
            </when>
            <otherwise>
              <choose>
                <when test="category2 != null and category2 != ''">
                  <![CDATA[AND cate.CATEGORYID in (select categoryid from category.t_category start with categoryid = #{category2} connect by prior  categoryid = parentcategoryid)]]>
                </when>
                <otherwise>
                  <if test="category1 != null and category1 !=''" >
                     <![CDATA[AND cate.CATEGORYID in (select categoryid from category.t_category start with categoryid =  #{category1} connect by prior  categoryid = parentcategoryid)]]>
                  </if>
                </otherwise>
              </choose>
            </otherwise>
          </choose>
        </if>
        <if test="categoryType != null and categoryType == 2">
              <choose>
                <when test="category2 != null and category2 != ''">
                  <![CDATA[AND cate.CATEGORYID = #{category2}]]>
                </when>
                <otherwise>
                  <if test="category1 != null and category1 !=''" >
                     <![CDATA[AND cate.CATEGORYID in ((select storecategoryid from store.t_store_category  t  start with storecategoryid = #{category1} connect by prior  storecategoryid = parentcategoryid))]]>
                  </if>
                </otherwise>
              </choose>
        </if>

            
