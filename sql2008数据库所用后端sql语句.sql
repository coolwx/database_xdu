USE [master]
GO
/****** Object:  Database [StudentInformation]    Script Date: 2020/12/24 14:23:53 ******/
CREATE DATABASE [StudentInformation] ON  PRIMARY 
( NAME = N'StudentInformation', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\StudentInformation.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'StudentInformation_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\StudentInformation_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StudentInformation].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StudentInformation] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StudentInformation] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StudentInformation] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StudentInformation] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StudentInformation] SET ARITHABORT OFF 
GO
ALTER DATABASE [StudentInformation] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StudentInformation] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [StudentInformation] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StudentInformation] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StudentInformation] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StudentInformation] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StudentInformation] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StudentInformation] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StudentInformation] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StudentInformation] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StudentInformation] SET  DISABLE_BROKER 
GO
ALTER DATABASE [StudentInformation] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StudentInformation] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StudentInformation] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StudentInformation] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StudentInformation] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StudentInformation] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StudentInformation] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StudentInformation] SET RECOVERY FULL 
GO
ALTER DATABASE [StudentInformation] SET  MULTI_USER 
GO
ALTER DATABASE [StudentInformation] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StudentInformation] SET DB_CHAINING OFF 
GO
USE [StudentInformation]
GO
/****** Object:  StoredProcedure [dbo].[Check_Dpeople]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Check_Dpeople]

@Dno int output,
@Dname varchar(50) output,
@Doldpeople int output,
@Dnewpeople int output

as
BEGIN
declare Vernier cursor local scroll for
select Dno,Dname,Dpeople from Department
Delete from Procedure_record
open Vernier
declare @Tmpno int,@Tmpname varchar(50),@Tmppeople int

fetch next from Vernier into @Tmpno,@Tmpname,@Tmppeople
while(@@FETCH_STATUS=0)
BEGIN
    declare @realpeople int
	set @realpeople=0
	select @realpeople = Dpeople from DepartmentView where Dno = @Tmpno
	
		
	if (@realpeople != @Tmppeople )
	BEGIN
		select @Dno=Dno,@Dname=Dname,@Doldpeople=@Tmppeople,@Dnewpeople=@realpeople from DepartmentView where Dno=@Tmpno
		Insert into Procedure_record values(@Dno,@Dname,@Doldpeople,@Dnewpeople)
		Update Department set Dpeople = @realpeople where Dno = @Tmpno
		fetch next from Vernier into @Tmpno,@Tmpname,@Tmppeople
	END
	Else
	BEGIN
		fetch next from Vernier into @Tmpno,@Tmpname,@Tmppeople
	END
END
close Vernier
END
GO
/****** Object:  StoredProcedure [dbo].[update_Cno]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_Cno]
	@oldCno int,
	@newCno int
As
Begin
   declare @return_num int
   alter table Student Disable Trigger all
   select @return_num=Cpeople from Class where @oldCno = Cno
   update Class set Cno = @newCno where Cno = @oldCno
   update Student set Cno = @newCno where Cno = @oldCno
   alter table Student Enable Trigger all
   return @return_num
 END 
GO
/****** Object:  Table [dbo].[Association]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Association](
	[Ano] [int] NOT NULL,
	[Aname] [varchar](50) NULL,
	[Atime] [datetime] NULL,
	[Aplace] [varchar](50) NULL,
 CONSTRAINT [PK_Association] PRIMARY KEY CLUSTERED 
(
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Class]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Class](
	[Cno] [int] NOT NULL,
	[Mno] [int] NULL,
	[Cyear] [int] NULL,
	[Cpeople] [int] NULL,
 CONSTRAINT [PK_Class] PRIMARY KEY CLUSTERED 
(
	[Cno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Department]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Department](
	[Dno] [int] NOT NULL,
	[Dname] [varchar](50) NULL,
	[Dplace] [varchar](100) NULL,
	[Ddorm] [int] NULL,
	[Dpeople] [int] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Dno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Major]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Major](
	[Mno] [int] NOT NULL,
	[Mname] [varchar](50) NULL,
	[Dno] [int] NULL,
 CONSTRAINT [PK_Major] PRIMARY KEY CLUSTERED 
(
	[Mno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Procedure_record]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Procedure_record](
	[Dno] [int] NULL,
	[Dname] [varchar](50) NULL,
	[Doldpeople] [int] NULL,
	[Dnewpeople] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SA]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SA](
	[Sno] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[SAyear] [int] NULL,
 CONSTRAINT [PK_SA] PRIMARY KEY CLUSTERED 
(
	[Sno] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Student]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[Sno] [int] NOT NULL,
	[Sname] [varchar](50) NULL,
	[Sage] [int] NULL,
	[Ssex] [varchar](4) NULL,
	[Cno] [int] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[Sno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[DepartmentPeopleView]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[DepartmentPeopleView](Dno,Dpeople)
as
select Department.Dno,SUM(Class.Cpeople)
from
Class inner join Major on Class.Mno = Major.Mno
inner join
Department on Major.Dno = Department.Dno
group by Department.Dno
GO
/****** Object:  View [dbo].[DepartmentView]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DepartmentView]
AS
SELECT  dbo.Department.Dno, dbo.Department.Dname, dbo.Department.Dplace, dbo.DepartmentPeopleView.Dpeople
FROM     dbo.Department INNER JOIN
               dbo.DepartmentPeopleView ON dbo.Department.Dno = dbo.DepartmentPeopleView.Dno

GO
/****** Object:  View [dbo].[AssociationPeopleView]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[AssociationPeopleView](Aname,Apeople)
as
select Association.Aname,COUNT(SA.Sno)
from
Association inner join SA on Association.Ano = SA.Ano
group by
Association.Aname
GO
/****** Object:  View [dbo].[ClassView]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[ClassView](Cno,Mname,Cyear,Dname,Cpeople)
as
select Class.Cno,Major.Mname,Class.Cyear,Department.Dname,Class.Cpeople
from Class,Major,Department
where
Class.Mno = Major.Mno and Major.Dno = Department.Dno
GO
/****** Object:  View [dbo].[StudentView]    Script Date: 2020/12/24 14:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[StudentView](Sno,Sname,Sage,Ssex,Dname,Cno,Ddorm)
as
select Student.Sno,Student.Sname,Student.Sage,Student.Ssex,Department.Dname,Student.Cno,Department.Ddorm
from
Student,Class,Major,Department
where
Student.Cno=Class.Cno and Class.Mno=Major.Mno and Major.Dno = Department.Dno
GO
INSERT [dbo].[Association] ([Ano], [Aname], [Atime], [Aplace]) VALUES (1, N'数学学会', CAST(0x00009E5E00000000 AS DateTime), N'B楼')
INSERT [dbo].[Association] ([Ano], [Aname], [Atime], [Aplace]) VALUES (2, N'天文学会', CAST(0x00009E7F00000000 AS DateTime), N'B楼')
INSERT [dbo].[Association] ([Ano], [Aname], [Atime], [Aplace]) VALUES (4, N'美术学会', CAST(0x0000A00B00000000 AS DateTime), N'A楼')
INSERT [dbo].[Association] ([Ano], [Aname], [Atime], [Aplace]) VALUES (5, N'垃圾学会', CAST(0x0000AB3500000000 AS DateTime), N'D楼')
INSERT [dbo].[Association] ([Ano], [Aname], [Atime], [Aplace]) VALUES (9, N'动漫会', CAST(0x0000AB3500000000 AS DateTime), N'A楼')
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1601013, 1, 2017, 101)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1603011, 7, 2016, 12)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1701012, 1, 2037, 191)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1701013, 1, 2018, 51)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1703012, 7, 2017, 300)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1802011, 4, 2018, 201)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1803011, 6, 2018, 1002)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (1803012, 7, 2018, 204)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (2003011, 7, 2020, 100)
INSERT [dbo].[Class] ([Cno], [Mno], [Cyear], [Cpeople]) VALUES (6030011, 7, 2020, 101)
INSERT [dbo].[Department] ([Dno], [Dname], [Dplace], [Ddorm], [Dpeople]) VALUES (1, N'通信工程', N'A楼', 7, 343)
INSERT [dbo].[Department] ([Dno], [Dname], [Dplace], [Ddorm], [Dpeople]) VALUES (2, N'电子信息', N'B楼', 8, 201)
INSERT [dbo].[Department] ([Dno], [Dname], [Dplace], [Ddorm], [Dpeople]) VALUES (3, N'计算机', N'C楼', 7, 1719)
INSERT [dbo].[Department] ([Dno], [Dname], [Dplace], [Ddorm], [Dpeople]) VALUES (4, N'机电工程', N'D楼', 9, 0)
INSERT [dbo].[Department] ([Dno], [Dname], [Dplace], [Ddorm], [Dpeople]) VALUES (5, N'数学学院', N'A楼', 7, 0)
INSERT [dbo].[Department] ([Dno], [Dname], [Dplace], [Ddorm], [Dpeople]) VALUES (6, N'经济', N'A楼', 7, 0)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (1, N'信息工程', 1)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (2, N'信息对抗', 1)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (3, N'通信系统', 1)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (4, N'雷达系统', 2)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (6, N'计算机科学与技术', 3)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (7, N'软件工程', 3)
INSERT [dbo].[Major] ([Mno], [Mname], [Dno]) VALUES (8, N'物联网', 3)
INSERT [dbo].[Procedure_record] ([Dno], [Dname], [Doldpeople], [Dnewpeople]) VALUES (1, N'通信工程', 100, 343)
INSERT [dbo].[SA] ([Sno], [Ano], [SAyear]) VALUES (1, 1, 2013)
INSERT [dbo].[SA] ([Sno], [Ano], [SAyear]) VALUES (1, 2, 2017)
INSERT [dbo].[SA] ([Sno], [Ano], [SAyear]) VALUES (7, 2, 2018)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (1, N'小铃铛', 18, N'男', 1701013)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (3, N'小花', 19, N'女', 1802011)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (6, N'销户', 23, N'男', 1701012)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (7, N'左手', 22, N'男', 1803011)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (8, N'阿水', 19, N'男', 1803012)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (9, N'惹晒', 21, N'男', 1803012)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (100, N'小王', 18, N'男', 1803011)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (130, N'曹王欣', 20, N'男', 1803012)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (220, N'朱翊轩', 20, N'男', 1803012)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (300, N'大爷', 30, N'男', 6030011)
INSERT [dbo].[Student] ([Sno], [Sname], [Sage], [Ssex], [Cno]) VALUES (1900, N'abc', 21, N'男', 1601013)
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Association]    Script Date: 2020/12/24 14:23:53 ******/
CREATE NONCLUSTERED INDEX [IX_Association] ON [dbo].[Association]
(
	[Aname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Department]    Script Date: 2020/12/24 14:23:53 ******/
CREATE NONCLUSTERED INDEX [IX_Department] ON [dbo].[Department]
(
	[Dname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Major]    Script Date: 2020/12/24 14:23:53 ******/
CREATE NONCLUSTERED INDEX [IX_Major] ON [dbo].[Major]
(
	[Mname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD  CONSTRAINT [FK_Class_Major] FOREIGN KEY([Mno])
REFERENCES [dbo].[Major] ([Mno])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [FK_Class_Major]
GO
ALTER TABLE [dbo].[Major]  WITH CHECK ADD  CONSTRAINT [FK_Major_Department] FOREIGN KEY([Dno])
REFERENCES [dbo].[Department] ([Dno])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Major] CHECK CONSTRAINT [FK_Major_Department]
GO
ALTER TABLE [dbo].[SA]  WITH CHECK ADD  CONSTRAINT [FK_SA_Association] FOREIGN KEY([Ano])
REFERENCES [dbo].[Association] ([Ano])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SA] CHECK CONSTRAINT [FK_SA_Association]
GO
ALTER TABLE [dbo].[SA]  WITH CHECK ADD  CONSTRAINT [FK_SA_Student] FOREIGN KEY([Sno])
REFERENCES [dbo].[Student] ([Sno])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SA] CHECK CONSTRAINT [FK_SA_Student]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Class] FOREIGN KEY([Cno])
REFERENCES [dbo].[Class] ([Cno])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_Class]
GO
ALTER TABLE [dbo].[Association]  WITH CHECK ADD  CONSTRAINT [CK_Association] CHECK  (([Ano]>(0)))
GO
ALTER TABLE [dbo].[Association] CHECK CONSTRAINT [CK_Association]
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD  CONSTRAINT [CK_Class] CHECK  (([Cno]>(0)))
GO
ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [CK_Class]
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD  CONSTRAINT [CK_Class_1] CHECK  (([Cyear]>(1900) AND [Cyear]<(2100)))
GO
ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [CK_Class_1]
GO
ALTER TABLE [dbo].[Class]  WITH CHECK ADD  CONSTRAINT [CK_Class_2] CHECK  (([Cpeople]>=(0)))
GO
ALTER TABLE [dbo].[Class] CHECK CONSTRAINT [CK_Class_2]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [CK_Department] CHECK  (([Dno]>(0)))
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [CK_Department]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [CK_Department_1] CHECK  (([Ddorm]>(0)))
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [CK_Department_1]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [CK_Department_2] CHECK  (([Dpeople]>=(0)))
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [CK_Department_2]
GO
ALTER TABLE [dbo].[Major]  WITH CHECK ADD  CONSTRAINT [CK_Major] CHECK  (([Mno]>(0)))
GO
ALTER TABLE [dbo].[Major] CHECK CONSTRAINT [CK_Major]
GO
ALTER TABLE [dbo].[SA]  WITH CHECK ADD  CONSTRAINT [CK_SA] CHECK  (([SAyear]>(1900) AND [SAyear]<(2100)))
GO
ALTER TABLE [dbo].[SA] CHECK CONSTRAINT [CK_SA]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [CK_Student] CHECK  (([Sno]>(0)))
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [CK_Student]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [CK_Student_1] CHECK  (([Sage]>(0)))
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [CK_Student_1]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [CK_Student_2] CHECK  (([Ssex]='男' OR [Ssex]='女'))
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [CK_Student_2]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Department"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 201
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DepartmentPeopleView"
            Begin Extent = 
               Top = 207
               Left = 57
               Bottom = 347
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DepartmentView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DepartmentView'
GO
USE [master]
GO
ALTER DATABASE [StudentInformation] SET  READ_WRITE 
GO
