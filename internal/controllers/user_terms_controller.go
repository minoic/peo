package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/peo/internal/configure"
)

type UserTermsController struct {
	web.Controller
	i18n.Locale
}

func (this *UserTermsController) Get() {
	this.TplName = "UserTerms.html"
	handleNavbar(&this.Controller)
	this.Data["u"] = 0
	type term struct {
		Title string
		Text  string
		Mute  string
	}
	this.Data["terms"] = []term{
		{
			Title: "使用服务与同意条款",
			Text:  "使用 " + configure.Viper().GetString("WebApplicationName") + " 提供的服务需同意下面列出的服务条款。请阅读以下主机服务条款和条件。订阅 " + configure.Viper().GetString("WebApplicationName") + " 的服务，即表示您同意受本协议（“协议”）的所有条款和条件的约束。如果您同意本协议的条款和条件，请单击“我接受”（或类似的语法），或选中相应的框以表明您的意图受这些条款和条件的约束，并继续进行帐户设置过程。您应打印或以其他方式保存本协议的副本以供将来参考。如果您不同意本协议的所有条款和条件，请单击浏览器上的“后退”按钮，并且不要订阅 " + configure.Viper().GetString("WebApplicationName") + " 的服务。" + configure.Viper().GetString("WebApplicationName") + " 同意仅在您同意接受此处包含的所有条款和条件约束的情况下才向您提供服务。",
			Mute:  "为了向您提供出色的服务，我们需要您同意本文​​档中的规则。",
		},
		{
			Title: "服务",
			Text:  "在初始注册时，您将从可用服务列表中选择您想要订阅的服务计划。服务的所有订阅都必须经过 " + configure.Viper().GetString("WebApplicationName") + " 的正式接受。当 " + configure.Viper().GetString("WebApplicationName") + " 向您提供订阅确认时，您对服务的订阅将被视为 " + configure.Viper().GetString("WebApplicationName") + " 接受。 " + configure.Viper().GetString("WebApplicationName") + " 保留出于任何原因拒绝向您提供任何服务的权利。尽管在本协议第17节中提供了我们的正常运行时间保证，但 " + configure.Viper().GetString("WebApplicationName") + " 保留根据需要中断对服务的访问以执行常规和紧急维护的权利。您可以随时订购其他服务，但前提是您同意支付此类附加服务当时的费用。在此，所有其他服务均应视为“服务”。提供的所有服务均受可用性以及本协议所有条款和条件的约束。",
			Mute:  "服务激活后，我们会立即通知您！不幸的是，有时我们不得不拒绝我们的服务或中断它们以进行维护。",
		},
		{
			Title: "对用户协议的修订",
			Text:  "我们可能会不时修订本协议。我们保留这样做的权利，并且您同意我们拥有这项单方面的权利。您同意对本协议的所有修改或变更在发布后立即生效并可以执行。更新或编辑的版本在发布后立即取代任何先前的版本，并且先前的版本不具有持续的法律效力，除非修订版明确引用了先前的版本并保持先前的版本或其部分有效。在任何法院认为本协议的任何修订无效或无效的情况下，双方均打算将本协议的先前有效版本视为有效且可以最大程度地执行。放弃-如果您未能定期查看本协议以确定是否有任何条款发生了更改，则您对此种疏忽承担全部责任，并且您同意，这种失败等同于您对放弃查看经修订条款的权利的肯定放弃。您对法律权利的疏忽不承担任何责任。",
			Mute:  "每隔一段时间，我们必须更新此协议。检查顶部的日期以查看上次修改的日期。只需继续使用我们的服务，向我们表明您接受更改。",
		},
		{
			Title: "知识产权",
			Text:  "在您与 " + configure.Viper().GetString("WebApplicationName") + " 之间， " + configure.Viper().GetString("WebApplicationName") + " 承认，它不对由其提供的内容（包括但不限于文本，软件，音乐，声音，视听作品，电影，照片，动画，视频和图形）享有所有权，您可以在您的网站上使用（“您的内容”）。您在此授予 " + configure.Viper().GetString("WebApplicationName") + " 非独占的，全球范围内的免版税许可，仅在您的利益和允许 " + configure.Viper().GetString("WebApplicationName") + " 的前提下，可以在Internet上以及通过Internet复制，制作衍生作品，展示，表演，使用，广播和传播您的内容。履行本协议项下的义务。",
			Mute:  "您所有的内容都属于您-不是 " + configure.Viper().GetString("WebApplicationName") + " ！您只是在授予 " + configure.Viper().GetString("WebApplicationName") + " 权限以将您的内容链接到Internet。",
		},
		{
			Title: "内容和可接受的使用政策",
			Text:  "如果您的行为违反了可接受的用途，或者如果您的最终用户或下游客户的任何行为违反了可接受的规定，则 " + configure.Viper().GetString("WebApplicationName") + " 可以单方面决定立即终止您对服务的访问并终止本协议。",
			Mute:  "当您将我们提供的服务用于非法、政治敏感、色情等不可被接受内容时，您允许我们禁止对您的文件或数据的公共访问。",
		},
		{
			Title: "零容忍垃圾邮件政策",
			Text:  " " + configure.Viper().GetString("WebApplicationName") + " 保留随时通过在其网站上发布修改后的策略来修改反垃圾邮件策略的权利。您同意监视 " + configure.Viper().GetString("WebApplicationName") + " 主页上的反垃圾邮件策略的任何更改。您在反垃圾邮件政策的任何更改生效之日后继续使用服务，即表示您有意受到此类更改的约束。",
			Mute:  "没有人喜欢垃圾邮件！您同意遵守 " + configure.Viper().GetString("WebApplicationName") + " 的反垃圾邮件政策。",
		},
		{
			Title: "付款",
			Text:  "服务付款应在此类付款涵盖的时间段之前支付。除非并且直到您遵循本协议中规定的 " + configure.Viper().GetString("WebApplicationName") + " 的取消程序，否则服务会自动重复收费。 除非您和我们分别协商，并通过单独的书面协议确认，否则您选择的服务的初始费用和经常性费用应与初始在线订购表中的规定相同。所有开办费和特别编程费均不予退还。服务费需提前支付。未按时支付服务费可能会导致服务暂停或终止。",
			Mute:  "服务费需提前支付，它可以帮助我们保持网络运行。如果您决定停止为服务付费，我们将暂停服务。",
		},
		{
			Title: "数据丢失",
			Text:  "您同意您对 " + configure.Viper().GetString("WebApplicationName") + " 服务的使用应自担风险，并且 " + configure.Viper().GetString("WebApplicationName") + " 对与其服务有关的任何数据丢失概不负责。您全权负责创建内容的备份。如果在我们自己的例行维护期间，我们确实创建了您的内容的备份，之后您又要求我们将其还原到您的帐户，则我们不能保证我们能够这样做，或者由于以下原因，您的内容不会受到损害：初始数据丢失或随后的还原过程。为此，我们强烈建议您建立自己的例行备份过程，并定期测试从备份媒体还原文件的过程，以确保您正在进行可行的备份。如果您希望 " + configure.Viper().GetString("WebApplicationName") + " 为您提供常规备份服务，除了本协议提供的服务之外，请与我们联系。作为常规服务的一项附加服务，我们提供许多不同的备份解决方案，并且所有此类服务都是通过单独的书面协议提供的。",
			Mute:  "我们会尽力保护您的数据！由于现实世界中的场景，例如火山和小行星，数据丢失的机会总是很小。我们建议为您的项目制定一个好的备份计划。",
		},
		{
			Title: "资源使用与安全",
			Text:  "除非法律明确许可，否则您不得从网站和/或材料中进行翻译，逆向工程，反编译，反汇编或制作衍生作品。您在此同意不使用任何自动设备或手动过程来监视或复制本网站或材料，也不会使用任何设备，软件，计算机代码或病毒来干扰或试图破坏或破坏我们的服务和网站或任何通信在上面。如果您不遵守本协议的这一规定并引起法律事件，除了向 " + configure.Viper().GetString("WebApplicationName") + " 提供金钱损失和其他补救措施外，您在此同意支付5000.00元的违约赔偿金，以及与追回这些损害赔偿有关的任何费用，包括律师费和费用。",
			Mute:  "我们的律师还希望我们在条款中加入您同意不对 " + configure.Viper().GetString("WebApplicationName") + " 进行任何敌对行为的条款。您可能知道这意味着什么；入侵，破坏或反向工程我们的系统。",
		},
		{
			Title: "责任限制",
			Text:  "您对自己的网站的正常运行和/或在您控制下的业务行为以及所有其他事项完全负责。在任何情况下， " + configure.Viper().GetString("WebApplicationName") + " 对因您对本网站和/或业务的运营或未能对您的网站和/或业务的运营造成的或与之有关的任何损害均不对您负责。",
			Mute:  "您同意，对于因您的公司或网站的运营造成的损失， " + configure.Viper().GetString("WebApplicationName") + " 不承担任何责任。",
		},
	}
}
