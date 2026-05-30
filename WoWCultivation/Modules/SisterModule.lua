local Module = {}
Module.name = "SisterModule"
Module.enabled = false
Module.dialogQueue = {}
Module.isShowingDialog = false
Module.lastIdleChat = 0
Module.idleChatInterval = 180   -- 最少3分钟一次闲聊
Module.idleChatChance = 0.25    -- 25%概率触发
Module.lastClickChat = 0
Module.clickChatCooldown = 5

-- 提醒系统冷却（防止刷屏）
Module.alertCooldowns = {
    health = 0,     -- 自身血量警告冷却
    mana = 0,       -- 法力警告冷却
    cc = 0,         -- 被控制警告冷却
    tankHealth = 0, -- 坦克血量警告冷却
    healerDown = 0, -- 治疗阵亡警告冷却
    partyDead = 0,  -- 队友阵亡警告冷却
}
Module.ALERT_CD = {
    health = 30,
    mana = 40,
    cc = 25,
    tankHealth = 20,
    healerDown = 60,
    partyDead = 45,
}
Module.healthWarned = false    -- 是否已警告过低血量
Module.manaWarned = false      -- 是否已警告过低法力

-- ============================================================
-- 预制对话库
-- ============================================================

-- 点击小师妹时随机触发 — 日常互动对话（大幅扩充）
Module.CLICK_CHATS = {
    -- 关心型 (40条)
    "师兄，今天修炼辛苦了吗？灵儿帮你揉揉肩好不好~",
    "师兄你好像又变强了呢...灵儿都快跟不上了。",
    "师兄，灵儿给你泡了壶灵茶，趁热喝吧~",
    "嗯...师兄身上的灵气好温暖，灵儿想多待一会儿...",
    "师兄，你今天看起来心情不错呢，灵儿也跟着开心~",
    "师兄有没有想灵儿呀？...灵儿可是每天都在想你呢！",
    "师兄，外面天黑了，要灵儿陪你吗？",
    "灵儿刚才打了个喷嚏...是不是师兄在想我？",
    "师兄，你闻到了吗？灵儿新炼的丹药，香不香~",
    "师兄今天的灵力波动好强...灵儿在旁边都有点心慌...",
    "师兄，灵儿偷偷给你藏了块灵石，别告诉别人哦~",
    "你最近是不是太拼了？灵儿看着都心疼...",
    "师兄，灵儿想问你一个问题...算了，下次再说吧。",
    "师兄的修为越来越深厚了，灵儿在旁边都觉得安心呢~",
    "灵儿刚才看到一颗流星，许了个愿...嘿嘿，不告诉你~",
    "师兄，你有没有觉得...灵儿最近是不是长高了一点点？",
    "师兄，灵儿想给你唱首歌，但你不能笑我哦！",
    "你知道吗师兄，灵儿最喜欢看师兄修炼的样子了~",
    "师兄，灵儿今天学了一个新法术，要不要看？",
    "师兄的气息好安详...灵儿靠一下可以吗？就一下~",
    "师兄，你额头上都是汗...灵儿帮你擦擦~",
    "师兄的灵力好纯正...灵儿在旁边都能感受到你的道心。",
    "师兄，灵儿昨天去采了灵草，给你做了个护身符...",
    "师兄，你今天气色不错！是不是又突破了什么瓶颈？",
    "灵儿看师兄这几天眉头紧锁...是遇到什么难处了吗？",
    "师兄，你的手好凉...灵儿帮你暖暖~",
    "师兄，你今天说话特别温柔呢...灵儿喜欢这样。",
    "灵儿看到师兄的灵气中有一丝金色...这是要突破的前兆吗？",
    "师兄，灵儿给你缝了个香囊...虽然针脚不太好...",
    "师兄修炼了一整天了，快歇歇！灵儿给你准备了点心~",
    "灵儿觉得师兄最近的心境又提升了，整个人都不一样了呢！",
    "师兄，你的剑法越来越纯熟了，灵儿在后面看得心驰神往~",
    "师兄，灵儿发现你的灵力运转好像更流畅了...是不是又参悟了什么？",
    "师兄，你眼睛里有光芒...灵儿觉得那是道心的光辉。",
    "灵儿刚才看到师兄打坐入定了好久...好厉害！",
    "师兄，灵儿帮你把道袍叠好了...虽然有点皱...",
    "师兄笑起来的时候最好看了...所以你要多笑笑！",
    "师兄，你喝水吗？灵儿用灵力温好了~",
    "师兄，你身上的灵力味道好特别...灵儿闭着眼睛都能认出来。",
    "灵儿看着师兄就觉得安心...这大概就是依恋吧？",

    -- 撒娇型 (40条)
    "师兄师兄！灵儿无聊了，你陪灵儿说说话嘛~",
    "哼，师兄都不理灵儿了...灵儿生气了！...才怪~",
    "师兄~灵儿想吃灵果，你给灵儿摘嘛~",
    "师兄，灵儿做了一个好可怕的梦...可以牵着你的衣角吗？",
    "师兄~灵儿今天扎的头发好看吗？不许说不！",
    "师兄师兄师兄！你快看灵儿新学的法术！",
    "灵儿不管，师兄今天必须陪灵儿逛坊市！",
    "师兄~你的灵力分灵儿一点嘛，灵儿想要~",
    "哼哼，师兄是不是偷偷去看别的师妹了？灵儿会吃醋的！",
    "师兄~灵儿的发簪掉了，你帮灵儿捡一下嘛~",
    "师兄，灵儿困了...可以靠在你肩膀上眯一会儿吗？",
    "师兄！灵儿不是小孩子了！...虽然灵儿确实比你小很多...",
    "师兄师兄，灵儿脚酸了...能不能背灵儿走一段？",
    "哼，师兄又在偷偷修炼不叫灵儿！下次要带上灵儿！",
    "师兄~你今天还没有摸灵儿的头呢...灵儿等着呢~",
    "师兄！灵儿也要学那个功法！你不教灵儿灵儿就...就哭给你看！",
    "师兄师兄，你看灵儿新买的发带，好看不好看？",
    "灵儿想要师兄抱抱...什么！灵儿没有撒娇！灵儿是认真的！",
    "师兄，灵儿今天不想修炼了，你陪灵儿玩好不好~",
    "师兄~灵儿发现了一个好漂亮的地方，改天带你去！",
    "师兄！你看你看！灵儿学会御剑了！...虽然只能飞三尺高...",
    "师兄~灵儿想养一只小灵兽，你帮灵儿抓一只嘛~",
    "师兄师兄！灵儿今天帮你把修炼笔记整理好了！夸我！",
    "哼，师兄都不回灵儿的话...灵儿要在你道袍上画小猪！",
    "师兄~灵儿今晚不想一个人，你来陪灵儿好不好？",
    "师兄你偏心！你对灵兽比对灵儿还好！",
    "灵儿才不是小师妹！灵儿要当...要当什么来着？算了还是小师妹吧~",
    "师兄！灵儿要和你一起御剑！你带灵儿飞嘛~",
    "师兄师兄师兄师兄师兄！...没事，就是想叫叫你~",
    "灵儿不管不管不管！师兄今天不许修炼，必须陪灵儿！",
    "师兄~你看灵儿采的花环，漂亮吗？给你戴上！",
    "师兄，灵儿想学做饭...但是每次都烧糊，你一定得教灵儿！",
    "灵儿要是生气了就躲起来让师兄找不到！...但是你会来找灵儿的对吧？",
    "师兄~灵儿想听你讲外面的故事，灵儿都没出过山门...",
    "灵儿好想变成一只小鸟，这样就能一直跟着师兄了~",
    "师兄，你为什么对灵儿这么好？...不管，反正灵儿赖上你了！",
    "灵儿觉得师兄比所有人都好！比掌门都好！...别告诉掌门哦~",
    "师兄~你什么时候教我你自创的那个剑招？灵儿眼馋好久了！",
    "师兄哥哥！灵儿就想这么叫你，不能拒绝！",
    "师兄，灵儿有时候想...如果你是亲哥哥就好了，但又不太想...",

    -- 暧昧型 (50条)
    "师兄...灵儿有时候会想，如果我不是你师妹就好了...",
    "师兄的灵力好温暖...灵儿想一直这样待着。",
    "师兄，你说...修仙之人也会有心动的感觉吗？",
    "灵儿做了一个梦，梦里师兄说了一句话...但灵儿醒来忘了...",
    "师兄，你的眼神好认真...灵儿看得脸都红了...",
    "灵儿有时候会想，前世的我们是不是也认识呢？",
    "师兄...如果有一天你飞升了，会带上灵儿吗？",
    "师兄，你有没有觉得...我们之间好像有什么说不清的东西？",
    "灵儿最近总觉得心跳好快...不知道是不是修炼走岔了...",
    "师兄，灵儿许了一个愿望...关于你的...但你不能问！",
    "师兄，你说灵儿要是化形了...你会不会不认识我了？",
    "灵儿有时候看着师兄修炼的背影，会莫名其妙地发呆...",
    "师兄...灵儿不想让你受伤，所以你要好好保护自己哦。",
    "师兄，你知道灵儿为什么总是跟着你吗？因为...因为你是师兄嘛！",
    "师兄，灵儿发现你的灵力波动和别人的不一样...特别温柔...",
    "如果可以的话...灵儿想永远做师兄的师妹...",
    "师兄，灵儿刚才偷偷看了你一眼...你不会生气吧？",
    "师兄的修为越来越深了...灵儿有点担心，你会不会忘了我？",
    "灵儿觉得...和师兄在一起的每一天都是最好的修炼。",
    "师兄...灵儿有些话想说了很久，但还是再等等吧...",
    "师兄，灵儿昨晚看到月亮特别圆...就想起你了。",
    "如果师兄是灵儿的道侣...啊！灵儿什么都没说！",
    "师兄，灵儿有时候会想...这算不算是缘分呢？",
    "师兄你有没有觉得...我们的距离好像越来越近了？",
    "灵儿偷偷在师兄的灵茶里加了一颗蜜枣...甜吗？",
    "师兄...灵儿总是不自觉地想靠近你，这是什么感觉？",
    "师兄，你知道灵儿最喜欢什么时辰吗？...是你在我身边的每一个时辰。",
    "灵儿觉得...修仙路上遇到师兄，是上天给灵儿最好的机缘。",
    "师兄，你的名字...灵儿每次念到都会不自觉地笑。",
    "灵儿有时候会想，要是能一直一直这样和你在一起就好了。",
    "师兄，你有没有注意到？每次你靠近的时候，灵儿的灵力都会波动...",
    "灵儿做了一个决定...但这个秘密要等到合适的时机再告诉你。",
    "师兄，你的心意灵儿其实...哎呀，今天天气真好！",
    "有没有人说过，师兄认真起来的样子很迷人？...灵儿是第一个对吗？",
    "师兄，灵儿昨天偷偷画了你的画像...画得不好，但灵儿会好好收着。",
    "如果可以，灵儿想和师兄一起看遍修仙界的日出日落。",
    "师兄，你是不是也感觉到了？我们之间那种...默契？",
    "灵儿总是在想...如果有一天灵儿不见了，师兄会着急吗？",
    "师兄...灵儿不怕修仙难，就怕你不在身边。",
    "师兄，你知道为什么灵儿选你做师兄吗？因为第一眼就觉得...特别。",
    "灵儿有时候偷偷想...如果下辈子还能遇到师兄就好了。",
    "师兄，灵儿的心事像灵泉一样，看似平静，其实底下暗流涌动...",
    "灵儿觉得...你和别人都不一样，你就是你，独一无二的师兄。",
    "师兄，你的背影灵儿能认出千万人中的一个...灵儿是不是中毒了？",
    "师兄...灵儿偷偷存了好多灵石，想给你买一件礼物...",
    "灵儿最近总做一个梦...梦见师兄拉着灵儿的手，走在花海里...",
    "师兄，如果有一天灵儿变得更好了，你会不会多看我一眼？",
    "灵儿觉得...修仙最难的其实不是功法，而是守住一颗心。",
    "师兄，有些话灵儿憋了很久...但还是觉得现在不是时候。",
    "如果时间能停在这一刻就好了...师兄在，灵儿也在。",

    -- 日常拌嘴 (30条)
    "师兄你又偷吃灵果！给灵儿也留一点嘛！",
    "哼，师兄的功法练得再好，做饭还是不如灵儿！",
    "师兄你听说了吗？隔壁峰的师兄好像有了道侣...才不是羡慕呢！",
    "师兄，灵儿觉得你今天的发型有点乱...过来，灵儿帮你整理！",
    "师兄你是不是又熬夜修炼了？黑眼圈都出来了，真是的...",
    "师兄，灵儿昨天看你的剑法有点走形，是不是偷懒了？",
    "哼，师兄再这样下去，灵儿可要去找别的师兄了！...开玩笑的啦~",
    "师兄，你是不是把灵儿藏的零食吃了？承认吧！",
    "师兄，你今天的修炼效率好低哦...是不是在想别的事情？",
    "灵儿觉得师兄最近好像胖了...是不是灵儿做饭太好吃了？",
    "师兄！你又忘了灵儿交代你的事情！罚你今天陪灵儿！",
    "师兄，你打坐的时候能不能别打呼噜...灵儿都听到了哦！",
    "师兄，灵儿刚才看到你和别的道友说话...哼，没什么。",
    "灵儿才没有吃醋！灵儿只是...只是觉得师兄应该多陪灵儿！",
    "师兄，你身上怎么有别的灵兽的味道...灵儿闻到的！",
    "师兄你今天话好少...是不是灵儿哪里惹你生气了？",
    "哼！师兄昨天说好要教灵儿法术的！又放灵儿鸽子！",
    "师兄你的道袍穿反了！...骗你的~看把你紧张的~",
    "师兄，灵儿今天跟你比试！输了的人请吃灵果！",
    "师兄你看！灵儿学会了你上次那个剑招...虽然歪了一点...",
    "师兄你是不是又在打瞌睡？灵儿看到你眼皮在打架了！",
    "别以为灵儿不知道！你上次偷偷给灵兽喂灵药，都没给灵儿留！",
    "师兄你今天怎么这么帅...是不是偷偷用了什么焕颜术？",
    "师兄师兄~你看那边那个仙子，她好像在看你呢！...呵呵看把你紧张的~",
    "灵儿觉得师兄今天肯定没吃饭...因为你的灵气都不太稳！",
    "师兄~你上次答应带灵儿去采药的，今天不许跑！",
    "灵儿才不是担心你！灵儿是...是怕你丢了没人给灵儿做饭！",
    "师兄你又在想什么？灵儿叫你三声了！",
    "师兄你今天啰嗦得像掌门真人！...掌门真人别打我！",
    "师兄你知道吗？灵儿其实偷偷在背后叫你...算了不说了~",

    -- 修炼交流 (30条)
    "师兄，你修炼的时候都在想什么？灵儿总是静不下心...",
    "灵儿觉得修炼最难的不是功法，是定力。师兄你是怎么做到的？",
    "师兄，你觉得灵力和真气最大的区别是什么？",
    "灵儿昨天尝试了一种新的吐纳方法，效果出奇地好！",
    "师兄，你突破的时候是什么感觉？灵儿好想知道~",
    "灵儿最近在参悟剑意...但总觉得差那么一点点，师兄指点一下呗？",
    "师兄，你说飞升之后的世界是什么样的？",
    "灵儿觉得丹道比剑道难多了...师兄你偏科！什么都会！",
    "师兄，你听说过'道心种魔'吗？听起来好吓人...",
    "灵儿最近对阵法很感兴趣，师兄你懂阵法吗？",
    "师兄，你有没有遇到过心魔？灵儿好怕...",
    "修炼一途，根骨、悟性、机缘缺一不可...师兄你已经占了几样了？",
    "师兄，你相信前世今生吗？灵儿总觉得以前见过你。",
    "灵儿觉得天地灵气最近有点躁动...是不是有什么大事要发生？",
    "师兄，你有没有试过用灵力煮茶？灵儿试过，茶壶炸了...",
    "灵儿觉得每次修炼完最难的是收功...容易走神。",
    "师兄，你修炼了这么多年，最大的心得是什么？",
    "灵儿觉得修仙最重要的不是天赋，而是坚持！...虽然灵儿天赋也挺好~",
    "师兄，你想过飞升以后要做什么吗？",
    "灵儿觉得你的灵力运转路线很独特...是自创的吗？",
    "师兄，你觉得什么属性的功法最适合灵儿？",
    "灵儿最近发现，心情好的时候修炼效率特别高！",
    "师兄，修仙路上...你会一直带着灵儿对吗？",
    "灵儿昨晚梦到自己修炼到了大乘期...醒来发现灵力一点都没涨。",
    "师兄，你说修仙和修心，哪个更重要？",
    "灵儿觉得修炼就像种灵植一样，急不来的...但灵儿还是急！",
    "师兄，你有没有后悔过走上修仙这条路？",
    "灵儿有时候想...如果能和师兄一起修炼到永远就好了。",
    "师兄，你教灵儿的那个功法，灵儿练成了！...一部分。",
    "修仙界的路很长很长...但有师兄在身边，灵儿就不怕了。",
}

-- 时间段特殊对话
Module.TIME_CHATS = {
    -- 早晨 6-10点
    morning = {
        "师兄早安~新的一天又开始啦，灵儿给你准备了早膳！",
        "师兄，清晨的灵气最纯净了，快起来修炼吧~",
        "嗯...师兄还在睡吗？灵儿叫你起床啦~",
        "师兄，今天的朝霞好美，灵儿想和你一起看~",
        "师兄早安！灵儿昨晚梦见你了...才不告诉你梦到了什么！",
        "晨露凝香，灵气氤氲...师兄，此时吐纳最佳！",
        "师兄~太阳晒到屁股啦！快起来晨练！",
        "早起的鸟儿有灵虫吃...师兄你是早起的大师兄！",
        "灵儿刚去采了晨露，给师兄泡了杯清心茶~",
        "师兄，晨光熹微，此时修炼事半功倍哦！",
    },
    -- 中午 11-13点
    noon = {
        "师兄，到午膳时间了，灵儿做了你爱吃的灵米饭~",
        "师兄，太阳好大，要不要灵儿给你撑把伞？",
        "师兄，中午了，休息一下吧，灵儿给你扇扇风~",
        "灵儿觉得师兄中午应该小憩一会儿...不然灵儿会担心的。",
        "师兄~灵儿午膳做多了，你要帮灵儿吃完哦！",
        "午时阳气最盛，师兄注意不要强行运功哦~",
        "灵儿做了凉拌灵笋，师兄尝尝？",
        "师兄，正午的太阳下有灵光闪现...注意到了吗？",
        "中午不打坐，下午没精神！师兄快休息~",
        "灵儿中午想小睡一会儿...师兄帮灵儿看着，别让人打扰~",
    },
    -- 下午 14-17点
    afternoon = {
        "师兄，下午的灵脉好像特别活跃呢~",
        "师兄，灵儿下午看到一个修行的好地方，明天带你去？",
        "师兄~灵儿有点犯困...可以靠着你看会儿书吗？",
        "师兄，午后的阳光暖暖的，灵儿想在师兄旁边打个盹~",
        "灵儿觉得下午最适合修炼了...因为师兄在身边呀~",
        "师兄，下午茶时间到！灵儿准备了灵露糕点~",
        "午后灵气内敛，正适合静修悟道呢。",
        "师兄，下午的阳光透过树叶洒下来，好像碎金子一样~",
        "灵儿下午去采了些灵草，晚上给你熬汤！",
        "师兄~你下午都在看什么书？灵儿也想看~",
    },
    -- 傍晚 18-20点
    evening = {
        "师兄，夕阳好美啊...灵儿想和师兄一起看晚霞~",
        "师兄，今天也辛苦了，灵儿给你揉揉肩吧~",
        "师兄~傍晚的灵气好像特别温柔呢，和师兄一样。",
        "天快黑了，师兄今天还出去吗？灵儿在家等你~",
        "师兄，灵儿在观星台等你，今晚的星星一定很漂亮~",
        "晚霞漫天，如师兄的道心一般绚烂~",
        "师兄，落日余晖下你的影子好长...灵儿踩了一下~",
        "傍晚灵气阴阳交汇，师兄修炼时注意调和~",
        "师兄~灵儿准备了晚膳，今天有你爱吃的！",
        "暮色四合，师兄不觉得这是个说心里话的好时候吗？",
    },
    -- 夜晚 21-23点
    night = {
        "师兄，夜深了，你该休息了...灵儿给你铺好了床。",
        "师兄~夜里的灵气很凉，灵儿帮你暖被窝...不是那个意思啦！",
        "师兄，灵儿晚上一个人有点怕...能待在你旁边吗？",
        "师兄，灵儿想听你讲故事...睡不着嘛~",
        "师兄，你看今晚的月亮...灵儿觉得它好像在对你笑呢。",
        "月华如水，师兄不觉得此时最适合吐纳月灵吗？",
        "师兄~夜风吹得有点凉，披件衣服吧。",
        "灵儿晚上总是胡思乱想...想的最多的就是师兄。",
        "师兄你知道吗？灵儿晚上能看到别人看不到的灵光哦~",
        "夜色深沉，师兄还醒着...灵儿也陪你醒着。",
    },
    -- 深夜 0-5点
    midnight = {
        "师兄！你怎么还不睡觉！灵儿要生气了！",
        "师兄...灵儿睡不着...可以陪灵儿说说话吗？",
        "这么晚了师兄还在修炼？灵儿心疼你...",
        "师兄，灵儿做了个噩梦...可以牵着你的手吗？就一会儿~",
        "师兄，你什么时候休息？灵儿等你...等到你睡为止。",
        "子时灵气最阴，师兄小心别走火入魔了。",
        "师兄，夜深人静的时候...你会想家吗？",
        "灵儿起来喝水，看到师兄还没睡...就过来看看。",
        "师兄你是不是有心事？灵儿虽然小，但可以听你说。",
        "夜已过半，师兄快歇息...不要透支灵元。",
    },
}

-- 场景触发对话
Module.SCENE_CHATS = {
    -- 进入主城
    city = {
        "哇，城里好热闹！师兄，灵儿想去逛逛那家法宝铺~",
        "师兄，城里好多人啊...灵儿抓紧你的衣角，别走丢了~",
        "师兄师兄，你看那个摊位卖的好像是灵果！灵儿想吃~",
        "在城里灵力都充沛了不少呢，师兄感觉到了吗？",
        "师兄你看那边的拍卖行！灵儿听说那里有很多宝贝~",
        "城里的灵气好充沛...怪不得大家都喜欢待在这里。",
    },
    -- 进入副本/秘境
    dungeon = {
        "师兄，这里感觉好危险...灵儿有点怕，你要保护我哦！",
        "秘境里灵气好浓郁啊...师兄，灵儿觉得这里藏了不少宝贝~",
        "师兄小心！灵儿帮你看着后面！",
        "这里的阵法好复杂...师兄，灵儿好像感应到了什么...",
        "师兄，这个秘境阴气好重...灵儿直觉不太好。",
        "灵儿感应到这里有一股强大的灵力残留...有大能来过！",
    },
    -- 战斗中
    combat = {
        "师兄加油！灵儿在后面给你助威！",
        "师兄小心！那个妖怪要偷袭你！",
        "灵儿相信师兄一定可以赢的！",
        "师兄好厉害！灵儿看得眼花缭乱了~",
        "师兄！左侧有破绽！快闪！",
        "灵儿用自己的灵力护住师兄的心脉！",
    },
    -- 战斗结束
    combat_end = {
        "师兄赢了！灵儿就知道你是最棒的！",
        "师兄有没有受伤？让灵儿看看...还好没有~",
        "刚才好惊险！师兄你吓到灵儿了...",
        "师兄太强了！灵儿佩服得五体投地~",
        "师兄的剑法又精进了呢！灵儿都看不清了~",
        "战斗结束！师兄需要疗伤吗？灵儿给你准备丹药~",
    },
    -- 升级
    levelup = {
        "师兄突破了！灵儿好开心！",
        "师兄越来越厉害了...灵儿要加油跟上才行！",
        "恭喜师兄修为精进！灵儿为你骄傲~",
        "师兄的气息又强大了不少呢...灵儿在旁边都感受到了~",
        "师兄的灵力暴涨！灵儿感觉到你的丹田在共鸣！",
        "哇！师兄你身上放出光芒了！突破得好漂亮！",
    },
    -- 死亡
    dead = {
        "师兄！你没事吧？灵儿好担心你！",
        "师兄...灵儿不要你受伤...呜呜...",
        "师兄快起来！灵儿不要一个人！",
        "师兄...都是灵儿没用，没能帮到你...",
        "师兄！灵儿的心好痛...你一定要撑过去！",
        "师兄！你走了灵儿怎么办...快回来！",
    },
    -- 获得好装备
    loot_good = {
        "哇！师兄拿到了好厉害的灵宝！灵儿也沾沾光~",
        "师兄运气真好！灵儿在旁边都感受到了好运降临~",
        "好漂亮的灵宝！师兄戴上一定很帅气！",
        "这件灵宝灵气四溢！灵儿隔着老远都感应到了！",
        "师兄！这件灵宝的品阶不低啊！快让灵儿仔细看看~",
        "恭喜师兄获得异宝！这是天道的眷顾啊！",
    },
    -- 空闲很久
    idle_long = {
        "师兄？你还在吗？灵儿有点无聊...",
        "师兄是不是走神了？灵儿在你面前晃晃手~",
        "师兄，灵儿等你好久了...你是不是忘了灵儿还在这里？",
        "师兄~你到底在不在啊？灵儿想你了...",
        "灵儿一个人好无聊...师兄你什么时候回来陪灵儿？",
        "师兄~灵儿在这里数蚂蚁呢...第三十七只了...",
    },
    -- 新场景: 飞行/骑乘
    flying = {
        "哇！师兄在飞行！灵儿也想和你一起翱翔天际！",
        "御空飞行！师兄的风姿简直无敌了~",
        "师兄飞得好稳！灵儿坐在后面一点都不怕~",
        "从天上往下看，修仙界好小啊...师兄你看那边！",
    },
    -- 新场景: 钓鱼
    fishing = {
        "师兄在垂钓呢~灵儿帮你看着浮标！",
        "师兄，你说鱼会不会也修炼成妖？...灵儿只是随便问问！",
        "灵儿也想钓鱼...但是每次都被鱼抢走饵料...",
        "师兄钓到灵鱼了吗？灵儿晚上给你炖汤！",
    },
    -- 新场景: 交易/拍卖
    trading = {
        "师兄在买灵药吗？灵儿也想要一颗...",
        "这个价格好贵！师兄你会砍价吗？",
        "师兄你看那个丹药...灵儿觉得成色一般，不如师兄自己炼的！",
        "哇，拍卖行好热闹！师兄你要拍什么宝贝？",
    },
}

-- 节日特殊对话
Module.FESTIVAL_CHATS = {
    newyear = {
        "师兄新年快乐！灵儿给你准备了年糕~",
        "新的一年，灵儿会继续陪着师兄的！",
        "师兄，灵儿许了个新年愿望...是关于你的~",
    },
    lantern = {
        "师兄，灵儿做了个花灯，我们一起去放吧~",
        "师兄你看那边的花灯好漂亮！灵儿想要那个兔子灯~",
        "灵儿在花灯上写了个愿望...师兄猜猜写了什么？",
    },
    midautumn = {
        "师兄，中秋快乐！灵儿做了灵米月饼给你~",
        "师兄，今天的月亮好圆好美...灵儿想和你一起赏月。",
        "师兄，灵儿听说月宫里住着仙子...但灵儿觉得她一定不如灵儿可爱~",
    },
    valentine = {
        "师兄...今天是七夕...灵儿...没什么...就是想待在你旁边...",
        "师兄，灵儿编了个同心结...你要收下吗？",
        "七夕快乐...师兄...灵儿永远陪着你~",
    },
}

-- ============================================================
-- 战斗状态提醒对话
-- ============================================================

Module.ALERT_CHATS = {
    -- 自身血量低 (<35%)
    health_low = {
        "师兄！你气血不稳，快服丹药调息！",
        "师兄小心！你的护体灵气快撑不住了！",
        "师兄，灵儿感应到你气血亏虚...快回血！",
        "师兄的肉身要扛不住了！灵儿好担心！",
        "师兄！灵脉逆行，速速稳住气血！",
        "师兄！你的灵气护盾出现了裂痕！",
        "师兄血流不止！灵儿帮你止血！",
        "师兄你的灵力正快速流失...快找掩体！",
    },
    -- 自身血量极低 (<15%)
    health_critical = {
        "师兄！！你快不行了！灵儿害怕！！",
        "师兄！护体罡气将碎！快退！",
        "师兄——！不要硬撑！灵儿求你了！",
        "天哪师兄！你的灵气几近崩散！速速撤离！",
        "师兄！！生命之火即将熄灭！灵儿给你渡灵！",
        "不——！师兄你不能倒下！灵儿在呢！",
    },
    -- 法力/灵力低 (<20%)
    mana_low = {
        "师兄，灵力即将枯竭，注意调息~",
        "师兄的法力波动很微弱了...要不要先歇一歇？",
        "师兄，灵力不济时强行施法很危险的！",
        "灵儿感应到师兄的丹田灵气不足了，悠着点~",
        "师兄！你的灵力储备见底了！灵儿分你一点！",
        "师兄灵泉干涸...需要片刻回灵才行。",
    },
    -- 被控制
    cc_fear = {
        "师兄！心魔入侵了！快稳住神识！",
        "师兄被心魔所困！灵儿帮不了你...你要撑住！",
        "师兄！你的神魂波动异常！是恐惧术！",
        "稳住道心师兄！那是幻象！不是真的！",
    },
    cc_stun = {
        "师兄被封印了！灵儿好急...",
        "师兄！灵识被封锁了！快挣脱！",
        "师兄神识被封！灵儿为你护法！",
        "该死！谁封印了师兄的灵脉！",
    },
    cc_polymorph = {
        "师兄？你...你怎么变成灵兽了？！",
        "哈哈哈哈师兄你变成小动物了！...不对，灵儿该救你！",
        "哇师兄变成了小羊！...灵儿回头再笑，先救你！",
        "师兄中了变形术！灵儿帮你找解咒的方法！",
    },
    cc_root = {
        "师兄被禁锢了！脚下有阵法，小心！",
        "师兄走不动了？灵儿也想帮你...但灵儿不会解阵...",
        "师兄！你脚下有灵藤缠绕！小心！",
        "定身术！师兄不要慌，灵儿帮你看着周围！",
    },
    cc_silence = {
        "师兄被禁言了！法术无法施展！",
        "师兄的灵脉被封！暂时用不了功法了！",
        "沉默术！师兄现在是凡人之躯，要小心！",
    },
    cc_generic = {
        "师兄被控住了！灵儿在旁边干着急...",
        "师兄！灵儿感应到你的灵力被压制了！",
        "师兄动弹不得！灵儿好想帮你...",
        "谁在暗算师兄！灵儿帮不上忙...急死了！",
    },
    -- 坦克血量危险
    tank_danger = {
        "师兄！前排护法的气血告急！快支援！",
        "师兄，护阵之人快要撑不住了，帮他稳住！",
        "师兄注意！挡在前面的道友血量很危险了！",
        "前排道友危在旦夕！师兄请速援！",
        "护法在溃退！师兄快去稳住阵线！",
    },
    -- 治疗阵亡
    healer_down = {
        "师兄！疗伤道友陨落了！大家危险了！",
        "不好了师兄！护持灵脉的人倒了！速速自救！",
        "天啊！队伍没了治疗！师兄要更加小心！",
        "医修倒下了！师兄快服丹药自保！",
    },
    -- 队友阵亡
    party_dead = {
        "师兄，有同修倒下了...灵儿心里好难受...",
        "师兄！又有道友陨落了...要更加小心！",
        "又一位道友仙逝了...师兄一定要平安！",
        "道友倒下了一位...师兄，灵儿好怕。",
    },
    -- 新场景: 队友血量低
    party_low = {
        "师兄！有同修气血见底了！帮忙照看一下！",
        "师兄快看！那位道友快撑不住了！",
    },
    -- 新场景: BOSS 阶段转换
    boss_phase = {
        "师兄小心！这妖兽的气息突然变了！",
        "师兄！妖物似乎要施展大招了！小心！",
        "妖气暴涨！师兄做好准备！",
    },
    -- 新场景: 脱离战斗回复
    recovering = {
        "师兄慢慢调息，灵儿帮你护法。",
        "呼...总算缓过来了，师兄你还好吗？",
        "灵儿帮师兄检查一下伤势...还好没有大碍。",
        "师兄别急着走，先把灵力恢复好~",
    },
}

-- ============================================================
-- 练级指导数据
-- ============================================================

Module.LEVEL_GUIDE = {
    { min = 1,  max = 9,  zone = "艾尔文森林 / 丹莫罗 / 杜隆塔尔", desc = "新手村附近历练，稳固根基", continent = "东部大陆" },
    { min = 10, max = 19, zone = "西部荒野 / 洛克莫丹 / 贫瘠之地", desc = "初入江湖，小心野外的妖兽", continent = "东部大陆" },
    { min = 20, max = 29, zone = "赤脊山 / 湿地 / 石爪山脉", desc = "练气中期，可以尝试小秘境了", continent = "东部大陆" },
    { min = 30, max = 39, zone = "暮色森林 / 希尔斯布莱德 / 千针石林", desc = "练气后期，灵根初显，功法渐深", continent = "东部大陆" },
    { min = 40, max = 49, zone = "荆棘谷 / 荒芜之地 / 凄凉之地", desc = "筑基初期，野外危险增加，结伴而行", continent = "东部大陆" },
    { min = 50, max = 54, zone = "塔纳利斯 / 灼热峡谷 / 诅咒之地", desc = "筑基中期，灵脉渐通，可入高级秘境", continent = "东部大陆" },
    { min = 55, max = 59, zone = "燃烧平原 / 冬泉谷 / 希利苏斯", desc = "筑基后期，即将突破，蓄力待发", continent = "东部大陆" },
    { min = 58, max = 62, zone = "地狱火半岛", desc = "踏入外域，灵气骤变，万事小心！", continent = "外域" },
    { min = 60, max = 64, zone = "赞加沼泽 / 泰罗卡森林", desc = "外域中部，灵脉异变，新功法涌现", continent = "外域" },
    { min = 64, max = 67, zone = "纳格兰 / 刀锋山", desc = "外域精华区域，灵宝与机缘并存", continent = "外域" },
    { min = 67, max = 69, zone = "虚空风暴 / 影月谷", desc = "外域深处，灵气狂暴，强敌环伺", continent = "外域" },
    { min = 68, max = 72, zone = "北风苔原 / 嚎风峡湾", desc = "初入诺森德，冰灵之气凛冽！", continent = "诺森德" },
    { min = 72, max = 74, zone = "龙骨荒野 / 灰熊丘陵", desc = "诺森德腹地，龙灵遗迹密布", continent = "诺森德" },
    { min = 74, max = 76, zone = "祖达克 / 索拉查盆地", desc = "冰封高原，灵兽横行，小心行事", continent = "诺森德" },
    { min = 76, max = 78, zone = "风暴峭壁 / 冰冠冰川外围", desc = "逼近天灾腹地，灵气阴寒刺骨", continent = "诺森德" },
    { min = 78, max = 80, zone = "冰冠冰川 / 冠军的试炼", desc = "终极秘境在望，为渡劫做准备！", continent = "诺森德" },
}

-- 升级时触发的练级指导
Module.LEVEL_TIPS = {
    [10] = "师兄已到10级！可以学习初级专业技能了，灵儿建议至少学一个采集类~",
    [15] = "师兄15级了，可以去怒焰裂谷等初级秘境历练了！",
    [20] = "师兄20级！可以学习骑术了，有了灵兽坐骑就方便多了~",
    [30] = "师兄30级了！血色修道院是个好去处，记得组队哦~",
    [40] = "师兄40级了！可以骑更快的灵兽了！灵儿好期待~",
    [50] = "师兄50级了！可以去玛拉顿和祖尔法拉克历练，那边的灵宝不错！",
    [55] = "师兄55级，离外域不远了！先在黑石深渊磨练一番吧~",
    [58] = "师兄58级！可以去地狱火半岛了！外域的灵气截然不同，做好准备！",
    [60] = "师兄60级！外域的大门敞开了！骑上飞行灵兽翱翔天际吧！",
    [65] = "师兄65级，纳格兰的灵脉品质很高，去那里修炼事半功倍！",
    [68] = "师兄68级！诺森德在召唤你了！冰灵之气会助你突破元婴！",
    [70] = "师兄70级！可以学寒冷天气飞行了，在诺森德也能翱翔~",
    [74] = "师兄74级，祖达克和索拉查的灵气浓郁，正适合修炼！",
    [77] = "师兄77级！风暴峭壁和冰冠冰川就在前方，天灾灵气阴寒，多带丹药！",
    [80] = "师兄80级！！道行圆满，已至巅峰！高级秘境、宗门争锋，任你选择！灵儿为你骄傲~",
}

-- ============================================================
-- 事件注册
-- ============================================================

function Module:OnEnable()
    self.enabled = true
    local EM = WoWCultivation.Core.EventManager
    EM:Register("PLAYER_ENTERING_WORLD", function()
        self:OnEnteringWorld()
    end)
    EM:Register("PLAYER_LEVEL_UP", function(level)
        self:OnLevelUp(level)
    end)
    EM:Register("PLAYER_DEAD", function()
        self:OnPlayerDead()
    end)
    EM:Register("PLAYER_REGEN_DISABLED", function()
        self:OnCombatStart()
    end)
    EM:Register("PLAYER_REGEN_ENABLED", function()
        self:OnCombatEnd()
    end)
    EM:Register("CHAT_MSG_LOOT", function(msg)
        self:OnLoot(msg)
    end)
    EM:Register("ZONE_CHANGED", function()
        self:OnZoneChanged()
    end)
    EM:Register("ZONE_CHANGED_INDOORS", function()
        self:OnZoneChanged()
    end)

    -- 状态提醒事件
    EM:Register("UNIT_HEALTH", function(unit)
        self:OnUnitHealth(unit)
    end)
    EM:Register("UNIT_POWER_UPDATE", function(unit, powerType)
        self:OnUnitPower(unit, powerType)
    end)
    EM:Register("UNIT_AURA", function(unit)
        self:OnUnitAura(unit)
    end)
    EM:Register("PARTY_MEMBER_DISABLE", function()
        self:OnPartyMemberDown()
    end)
    EM:Register("UNIT_DESTROYED", function(unit)
        self:OnUnitDestroyed(unit)
    end)

    -- 空闲闲聊定时器 + 状态巡检
    self:StartIdleTimer()
    self:StartStatusCheck()
end

function Module:OnDisable()
    self.enabled = false
    if self.idleTimer then
        self.idleTimer:Cancel()
        self.idleTimer = nil
    end
    if self.statusTimer then
        self.statusTimer:Cancel()
        self.statusTimer = nil
    end
end

-- ============================================================
-- 核心对话系统
-- ============================================================

function Module:OnEnteringWorld()
    if WoWCultivationCharDB.firstLoad then
        self:ShowFirstLoadDialog()
        WoWCultivationCharDB.firstLoad = false
    else
        -- 登录时根据时间打招呼
        local greeting = self:GetTimeGreeting()
        if greeting then
            C_Timer.After(3, function()
                self:Say(greeting)
            end)
        end
    end
end

function Module:ShowFirstLoadDialog()
    local level = UnitLevel("player")
    local _, englishClass = UnitClass("player")
    local realmInfo = WoWCultivation.Data.Realm[level]
    local sectInfo = WoWCultivation.Data.Sect[englishClass]

    local realmName = realmInfo and realmInfo.bigRealm .. " · " .. realmInfo.name or "练气初期"
    local sectName = sectInfo and sectInfo.name or "散修"
    local spiritRoot = sectInfo and sectInfo.spiritRoot or "未知灵根"

    local dialog = {
        "师兄，你终于醒了！我是你的引路师妹·灵儿。",
        "你尚在" .. realmName .. "，修仙之路漫漫，且听我道来...",
        "你已拜入" .. sectName .. "，修炼" .. spiritRoot .. "之力。",
        "勤修功法，方能掌握更强大的术法。",
        "以后有什么不懂的，随时点击我即可。",
        "修仙界广阔，愿师兄早日飞升！...灵儿会一直陪着你的~",
    }
    self:ShowDialog(dialog)
end

function Module:ShowDialog(dialogSequence)
    if not dialogSequence or #dialogSequence == 0 then return end
    for _, line in ipairs(dialogSequence) do
        table.insert(self.dialogQueue, line)
    end
    if not self.isShowingDialog then
        self:ShowNextDialog()
    end
end

function Module:ShowNextDialog()
    if #self.dialogQueue == 0 then
        self.isShowingDialog = false
        if WoWCultivation.UI.SisterModel then
            WoWCultivation.UI.SisterModel:HideDialog()
        end
        return
    end

    self.isShowingDialog = true
    local text = table.remove(self.dialogQueue, 1)

    if WoWCultivation.UI.SisterModel then
        WoWCultivation.UI.SisterModel:ShowDialog(text)
    else
        WoWCultivation:Print("灵儿: " .. text)
    end

    C_Timer.After(3.5, function()
        self:ShowNextDialog()
    end)
end

function Module:Say(text)
    local FavorModule = WoWCultivation.Modules and WoWCultivation.Modules.FavorModule
    if FavorModule then
        local title = FavorModule:GetTitle()
        if title ~= "师兄" then
            text = string.gsub(text, "师兄", title)
        end
    end

    if WoWCultivation.UI.SisterModel then
        WoWCultivation.UI.SisterModel:ShowDialog(text)
    else
        WoWCultivation:Print("灵儿: " .. text)
    end
end

-- ============================================================
-- 随机对话选择
-- ============================================================

function Module:GetRandomFromList(list)
    if not list or #list == 0 then return nil end
    return list[math.random(1, #list)]
end

function Module:OnSisterClick()
    -- 点击小师妹触发随机对话
    local now = GetTime()
    if now - self.lastClickChat < self.clickChatCooldown then return end
    self.lastClickChat = now

    local text = self:GetRandomFromList(self.CLICK_CHATS)
    if text then
        self:Say(text)
    end
end

-- ============================================================
-- 时间段问候
-- ============================================================

function Module:GetTimeGreeting()
    local hour = tonumber(date("%H")) or 12
    local timeKey

    if hour >= 6 and hour < 10 then
        timeKey = "morning"
    elseif hour >= 10 and hour < 14 then
        timeKey = "noon"
    elseif hour >= 14 and hour < 18 then
        timeKey = "afternoon"
    elseif hour >= 18 and hour < 21 then
        timeKey = "evening"
    elseif hour >= 21 and hour < 24 then
        timeKey = "night"
    else
        timeKey = "midnight"
    end

    return self:GetRandomFromList(self.TIME_CHATS[timeKey])
end

-- ============================================================
-- 场景触发
-- ============================================================

-- OnLevelUp 已移至练级指导系统

function Module:OnPlayerDead()
    C_Timer.After(2, function()
        local text = self:GetRandomFromList(self.SCENE_CHATS.dead)
        if text then self:Say(text) end
    end)
end

function Module:OnCombatStart()
    -- 低概率在战斗开始时说话
    if math.random() < 0.15 then
        local text = self:GetRandomFromList(self.SCENE_CHATS.combat)
        if text then self:Say(text) end
    end
end

function Module:OnCombatEnd()
    -- 战斗结束较高概率说话
    if math.random() < 0.3 then
        local text = self:GetRandomFromList(self.SCENE_CHATS.combat_end)
        if text then self:Say(text) end
    end
end

function Module:OnLoot(msg)
    if not msg then return end
    local itemLink = msg:match("|c%x+|Hitem:.-|h%[.-%]|h|r")
    if not itemLink then return end
    local itemName, _, itemRarity = GetItemInfo(itemLink)
    if itemName and itemRarity and itemRarity >= 4 then
        if math.random() < 0.5 then
            local text = self:GetRandomFromList(self.SCENE_CHATS.loot_good)
            if text then self:Say(text) end
        end
    end
end

function Module:OnZoneChanged()
    local inInstance, instanceType = IsInInstance()
    if inInstance and (instanceType == "party" or instanceType == "raid") then
        if math.random() < 0.4 then
            local text = self:GetRandomFromList(self.SCENE_CHATS.dungeon)
            if text then self:Say(text) end
        end
    elseif not inInstance then
        local _, _, _, _, _, _, _, _, inCity = GetZonePVPInfo()
        if inCity and math.random() < 0.3 then
            local text = self:GetRandomFromList(self.SCENE_CHATS.city)
            if text then self:Say(text) end
        end
    end
end

-- ============================================================
-- 空闲闲聊定时器
-- ============================================================

function Module:StartIdleTimer()
    if self.idleTimer then
        self.idleTimer:Cancel()
    end

    -- 每60秒检查一次是否应该闲聊
    self.idleTimer = C_Timer.NewTicker(60, function()
        if not self.enabled then return end

        local now = GetTime()
        -- 检查冷却
        if now - self.lastIdleChat < self.idleChatInterval then return end

        -- 随机触发
        if math.random() < self.idleChatChance then
            self.lastIdleChat = now
            local text = self:GetRandomFromList(self.CLICK_CHATS)
            if text then self:Say(text) end
        end
    end)
end

-- ============================================================
-- 节日对话
-- ============================================================

function Module:CheckFestival()
    local month = tonumber(date("%m")) or 0
    local day = tonumber(date("%d")) or 0

    -- 元旦/新年
    if month == 1 and day == 1 then
        return self.FESTIVAL_CHATS.newyear
    -- 春节（简化为2月初）
    elseif month == 2 and day <= 15 then
        return self.FESTIVAL_CHATS.newyear
    -- 元宵
    elseif month == 2 and day >= 14 and day <= 16 then
        return self.FESTIVAL_CHATS.lantern
    -- 七夕
    elseif month == 8 and day >= 10 and day <= 12 then
        return self.FESTIVAL_CHATS.valentine
    -- 中秋
    elseif month == 9 and day >= 15 and day <= 20 then
        return self.FESTIVAL_CHATS.midautumn
    -- 圣诞/年末
    elseif month == 12 and day >= 24 then
        return self.FESTIVAL_CHATS.newyear
    end

    return nil
end

-- ============================================================
-- 状态提醒系统
-- ============================================================

function Module:CanAlert(key)
    local now = GetTime()
    if now - self.alertCooldowns[key] < self.ALERT_CD[key] then
        return false
    end
    self.alertCooldowns[key] = now
    return true
end

function Module:OnUnitHealth(unit)
    if not UnitIsFriend("player", unit) then return end
    -- 只在战斗中提醒
    if not InCombatLockdown() then
        self.healthWarned = false
        return
    end

    local healthPct = UnitHealth(unit) / math.max(1, UnitHealthMax(unit))

    -- 自身血量
    if unit == "player" then
        if healthPct < 0.15 and self:CanAlert("health") then
            self.healthWarned = true
            self:Say(self:GetRandomFromList(self.ALERT_CHATS.health_critical))
        elseif healthPct < 0.35 and not self.healthWarned and self:CanAlert("health") then
            self.healthWarned = true
            self:Say(self:GetRandomFromList(self.ALERT_CHATS.health_low))
        elseif healthPct > 0.6 then
            self.healthWarned = false
        end
        return
    end

    -- 队友血量 — 只在副本中提醒
    if not IsInInstance() then return end
    if not UnitInParty(unit) and not UnitInRaid(unit) then return end

    -- 坦克血量危险
    if unit == "party1" or unit == "raid1" then
        local role = UnitGroupRolesAssigned(unit)
        if role == "TANK" and healthPct < 0.3 and self:CanAlert("tankHealth") then
            self:Say(self:GetRandomFromList(self.ALERT_CHATS.tank_danger))
        end
    end
end

function Module:OnUnitPower(unit, powerType)
    if unit ~= "player" then return end
    if not InCombatLockdown() then
        self.manaWarned = false
        return
    end

    -- 只检查法力（0 = MANA）
    if powerType ~= "MANA" and powerType ~= 0 then return end

    local power = UnitPower("player", 0)
    local maxPower = UnitPowerMax("player", 0)
    if maxPower <= 0 then return end

    local pct = power / maxPower
    if pct < 0.2 and not self.manaWarned and self:CanAlert("mana") then
        self.manaWarned = true
        self:Say(self:GetRandomFromList(self.ALERT_CHATS.mana_low))
    elseif pct > 0.5 then
        self.manaWarned = false
    end
end

function Module:OnUnitAura(unit)
    if unit ~= "player" then return end
    if not InCombatLockdown() then return end
    if not self:CanAlert("cc") then return end

    -- 检查是否被控制
    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, spellId = UnitAura("player", i, "HARMFUL")
        if not spellId then break end

        local ccType = self:IdentifyCC(spellId)
        if ccType then
            local chatList = self.ALERT_CHATS["cc_" .. ccType] or self.ALERT_CHATS.cc_generic
            self:Say(self:GetRandomFromList(chatList))
            return
        end
    end
end

-- 识别控制类型
function Module:IdentifyCC(spellId)
    local ccMap = {
        -- 恐惧/心魔
        [5782] = "fear", [2094] = "fear", [6358] = "fear", [228918] = "fear",
        -- 昏迷
        [853] = "stun", [408] = "stun", [12809] = "stun", [1833] = "stun",
        -- 变形
        [118] = "polymorph", [28272] = "polymorph", [61305] = "polymorph",
        -- 定身
        [122] = "root", [33395] = "root", [23994] = "root",
    }
    return ccMap[spellId]
end

function Module:OnPartyMemberDown()
    if not IsInInstance() then return end
    if not self:CanAlert("healerDown") then return end

    -- 检查治疗是否阵亡
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) and UnitIsDeadOrGhost(unit) then
            local role = UnitGroupRolesAssigned(unit)
            if role == "HEALER" then
                self:Say(self:GetRandomFromList(self.ALERT_CHATS.healer_down))
                return
            end
        end
    end
end

function Module:OnUnitDestroyed(unit)
    if not IsInInstance() then return end
    if not UnitInParty(unit) and not UnitInRaid(unit) then return end
    if not self:CanAlert("partyDead") then return end
    self:Say(self:GetRandomFromList(self.ALERT_CHATS.party_dead))
end

-- 定时状态巡检（低频，只在副本战斗中）
function Module:StartStatusCheck()
    if self.statusTimer then
        self.statusTimer:Cancel()
    end

    self.statusTimer = C_Timer.NewTicker(5, function()
        if not self.enabled then return end
        if not InCombatLockdown() then return end
        if not IsInInstance() then return end

        -- 巡检队友血量
        for i = 1, 4 do
            local unit = "party" .. i
            if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
                local healthPct = UnitHealth(unit) / math.max(1, UnitHealthMax(unit))
                local role = UnitGroupRolesAssigned(unit)

                if role == "TANK" and healthPct < 0.25 and self:CanAlert("tankHealth") then
                    self:Say(self:GetRandomFromList(self.ALERT_CHATS.tank_danger))
                    return
                end
            end
        end

        -- 巡检治疗是否阵亡
        for i = 1, 4 do
            local unit = "party" .. i
            if UnitExists(unit) and UnitIsDeadOrGhost(unit) then
                local role = UnitGroupRolesAssigned(unit)
                if role == "HEALER" and self:CanAlert("healerDown") then
                    self:Say(self:GetRandomFromList(self.ALERT_CHATS.healer_down))
                    return
                end
            end
        end
    end)
end

-- ============================================================
-- 练级指导系统
-- ============================================================

function Module:OnLevelUp(level)
    C_Timer.After(1.5, function()
        -- 先说升级祝贺
        local text = self:GetRandomFromList(self.SCENE_CHATS.levelup)
        if text then self:Say(text) end

        -- 延迟后给出练级指导
        C_Timer.After(4, function()
            self:ShowLevelGuide(level)
        end)
    end)
end

function Module:ShowLevelGuide(level)
    -- 优先显示关键等级的专属提示
    local tip = self.LEVEL_TIPS[level]
    if tip then
        self:Say(tip)
        return
    end

    -- 否则显示通用区域指导
    local guide = self:GetLevelGuide(level)
    if guide then
        self:Say("师兄" .. level .. "级了，灵儿建议去" .. guide.zone .. "修炼~ " .. guide.desc)
    end
end

function Module:GetLevelGuide(level)
    for _, guide in ipairs(self.LEVEL_GUIDE) do
        if level >= guide.min and level <= guide.max then
            return guide
        end
    end
    return nil
end

-- 点击查看当前练级建议
function Module:ShowCurrentGuide()
    local level = UnitLevel("player")
    local guide = self:GetLevelGuide(level)

    if guide then
        self:Say("师兄当前" .. level .. "级，适合在" .. guide.continent .. "的" .. guide.zone .. "修炼。")
        C_Timer.After(3, function()
            self:Say(guide.desc)
        end)
    else
        self:Say("师兄" .. level .. "级...灵儿暂时没有适合的修炼指引，师兄自己探索吧~")
    end
end

WoWCultivation.Modules.SisterModule = Module
