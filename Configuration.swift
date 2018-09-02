//
//  Configuration.swift
//  classified
//
//  Created by Eman I on 4/8/16.
//  Copyright © 2016 Eman
//
import AVFoundation
import Parse

var currentWinEmoji = ""
var currentWinFeeling = ""
var currentWinDetails = ""
var currentFriendsList = [String]()
var currentFriendsPhoneList = [[String]]()
var currentFriendsEmails = [[String]]()
var viewsFromOtherControllers = 0
var emptyStringArray = [String]()
var emptyDoubleStringArray = [[String]]()
var feelingPlaceholder = ""
var showTheBar = false
var player2:AVAudioPlayer = AVAudioPlayer()
var winsObjectArray = [PFObject]()
var myWinsObjectArray = [PFObject]()
var favWinsObjectArray = [PFObject]()
var emptyPFArray = [PFObject]()
var filterLabel = "All Categories"
let currentUser = PFUser.current()
let currentUserId = PFUser.current()?.objectId
var currentWinSelected = PFObject(outDataWithClassName: "Wins", objectId: "ym0ExqG06P")
var fromLocation = ""
var userProfileName = ""
var winCreator = PFUser.current()
var deletedWin = false
var addedWin = false
var myOwnWin = false
var numTimesOnApp = UserDefaults.standard.integer(forKey: "numTimesOnApp")
var isFav = false
var imageToUpload: UIImageView!
var communityCatImage = UIImageView(image: UIImage(named: "Smiling.jpeg"))
var personalCatImage = UIImageView(image: UIImage(named: "Cool.jpeg"))
var fromPersonal = false
var seenNotifs = UserDefaults.standard.array(forKey: "seenNotifs") as? [String]// holds object ids for comm wins seen
var communityWinDict:[String:[String]] = [String:[String]]()
var notifsToBeSent = UserDefaults.standard.dictionary(forKey: "notifsToBeSent") as? [String:[String]] //holds notifs to send
var mySavedWins = UserDefaults.standard.dictionary(forKey: "mySavedWins") as? [String:[String]] // holds object ids personal wins
var lastNotifDate = UserDefaults.standard.object(forKey: "lastNotifDate") as? Date
var notifsSentPerDay = UserDefaults.standard.integer(forKey: "notifsSentPerDay")
var reminderDiff = UserDefaults.standard.integer(forKey: "reminderDiff")
var reminderStart = UserDefaults.standard.integer(forKey: "reminderStart")
var reminderEnd = UserDefaults.standard.integer(forKey: "reminderEnd")
var startMinSaved = UserDefaults.standard.integer(forKey: "startMinSaved")
var endMinSaved = UserDefaults.standard.integer(forKey: "endMinSaved")
var controllerToStayOn = false
var phoneNums = [String]()
var myPhoneArray = UserDefaults.standard.array(forKey: "myPhoneArray") as? [String]
var noLikeArray = UserDefaults.standard.array(forKey: "noLikeArray") as? [String]
var usernamePlaceHolder = ""
var numberVerified = UserDefaults.standard.integer(forKey: "numberVerified")
var tutCount = UserDefaults.standard.integer(forKey: "tutCount")
var tutCountMore = UserDefaults.standard.integer(forKey: "tutCountMore")
var tutCountFinal = UserDefaults.standard.integer(forKey: "tutCountFinal")
var tutCountApplause = UserDefaults.standard.integer(forKey: "tutCountApplause")
var tutCountCommunity = UserDefaults.standard.integer(forKey: "tutCountCommunity")
var tutCountProps = UserDefaults.standard.integer(forKey: "tutCountProps")
var tutCountNotif = UserDefaults.standard.integer(forKey: "tutCountNotif")
var tutCountCategory = UserDefaults.standard.integer(forKey: "tutCountCategory")
var askedForReview = UserDefaults.standard.integer(forKey: "askedForReview")
var profSeg = 0
var commTypeArray = [PFObject]()
var personalCommTypeArray = [PFObject]()
var commMessagesArray = [PFObject]()
var personalCommMessagesArray = [PFObject]()
var categoryPFAuthor = PFUser()
var specificMessageText = ""
var specificMessageAuthor = ""
var myCommTypesArray = UserDefaults.standard.array(forKey: "myCommTypesArray") as? [String]
var myCommTypesArrayPlaceholder = UserDefaults.standard.array(forKey: "myCommTypesArrayPlaceholder") as? [String]
var categoryName = ""
var categoryLikes = 0
var categoryDislikes = 0
var categoryDescription = ""
var categorySubs = 0
var categoryCreator = ""
var categoryId = ""
var personalCategoryId = ""
var categoryObjectId = ""
var personalCategoryObjectId = ""
var categoryWinCount = 0
var onlyPersonal = UserDefaults.standard.integer(forKey: "onlyPersonal")
var receiveReminders = UserDefaults.standard.integer(forKey: "receiveReminders")
var recentlyLoaded = true
var globalfeatureArray = [Feature]()


