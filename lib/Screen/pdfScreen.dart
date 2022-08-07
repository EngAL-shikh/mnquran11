
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


/// Represents the Homepage for Navigation
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  late bool _showToolbar;
  late bool _showScrollHead;
  late  bool prot;

  /// Ensure the entry history of Text search.
  LocalHistoryEntry? _historyEntry;

  @override
  void initState() {
    _showToolbar = false;
    _showScrollHead = true;
    prot = true;
    super.initState();
  }

  /// Ensure the entry history of text search.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  /// Remove history entry for text search.
  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.clearSearch();
    setState(() {
      _showToolbar = false;
    });
    _historyEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showToolbar
          ? AppBar(
        flexibleSpace: SafeArea(
          child: SearchToolbar(
            key: _textSearchKey,
            showTooltip: true,
            controller: _pdfViewerController,
            onTap: (Object toolbarItem) async {
              if (toolbarItem.toString() == 'Cancel Search') {
                setState(() {
                  _showToolbar = false;
                  _showScrollHead = true;
                  if (Navigator.canPop(context)) {
                    Navigator.maybePop(context);
                  }
                });
              }
              if (toolbarItem.toString() == 'noResultFound') {
                setState(() {
                  _textSearchKey.currentState?._showToast = true;
                });
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  _textSearchKey.currentState?._showToast = false;
                });
              }
            },
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFAFAFA),
      )
          : AppBar(
        centerTitle: true,
        title:const Text(
          'من بلاغة القرآن الجزء الثاني',
          style: TextStyle(color: Colors.black87),
        ),
        leading:
          IconButton(
            icon:const  Icon(
              Icons.search,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _showScrollHead = false;
                _showToolbar = true;
                _ensureHistoryEntry();
              });
            },
          ),

        actions: [


          IconButton(
            icon: Icon(
              Icons. bookmark,
              color: Colors.black54,
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),

          IconButton(
            icon: Icon(
              Icons. wifi_protected_setup,
              color: Colors.black54,
            ),
            onPressed: () {
             setState(() {
               prot=!prot;
             });
            },
          ),
//          IconButton(
//            icon: Icon(
//              Icons.zoom_in,
//              color: Colors.black87,
//            ),
//            onPressed: () {
//              _pdfViewerController.zoomLevel = 2;
//            },
//          ),
//          IconButton(
//            icon: Icon(
//              Icons.zoom_out,
//              color: Colors.black87,
//            ),
//            onPressed: () {
//              _pdfViewerController.zoomLevel = 0;
//            },
//          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFAFAFA),
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              SfPdfViewer.asset(

                'assets/lamasat.pdf',
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                canShowScrollHead: _showScrollHead,
                  scrollDirection:prot? PdfScrollDirection.vertical:PdfScrollDirection.horizontal,
                  pageLayoutMode: !prot?PdfPageLayoutMode.single:PdfPageLayoutMode.continuous,
                pageSpacing: 5,
                otherSearchTextHighlightColor: Colors.lightBlue,



              ),
             prot? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  //height: 150,
                  // color: Colors.red,
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(

                        decoration: BoxDecoration(

                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {

                                  _pdfViewerController.previousPage();
                                },
                                icon: const  Icon(
                                  Icons.arrow_circle_up,
                                  color: Colors.blue,
                                )),
                            IconButton(
                                onPressed: () {

                                  _pdfViewerController.nextPage();
                                },
                                icon: const Icon(
                                  Icons.arrow_circle_down,
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                      ),

                    ],

                  ),
                ),
              ):Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Align(
                 alignment: Alignment.bottomCenter,
                 child: Container(
                   //height: 150,
                    color: Colors.white,
                   child: Row(
                     mainAxisAlignment:MainAxisAlignment.center,
                     children: [
                       Container(

                         height: 60,


                         decoration: BoxDecoration(

                           //  color: Colors.white,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: Center(
                           child: Row(
                             mainAxisAlignment:MainAxisAlignment.center,
                             children: [
                               IconButton(
                                   onPressed: () {

                                     _pdfViewerController.previousPage();
                                   },
                                   icon: const  Icon(
                                     Icons.navigate_before,
                                     color: Colors.blue,
                                     size: 40,
                                   )),
                               SizedBox(width: 200,),
                               IconButton(
                                   onPressed: () {

                                     _pdfViewerController.nextPage();
                                   },
                                   icon: const Icon(
                                     Icons.navigate_next,
                                     color: Colors.blue,
                                     size: 40,
                                   )),
                             ],
                           ),
                         ),
                       ),

                     ],

                   ),
                 ),
             ),
              )
            ],
          ),
          Visibility(
            visible: _textSearchKey.currentState?._showToast ?? false,
            child: Align(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding:
                    EdgeInsets.only(left: 15, top: 7, right: 15, bottom: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    child:const  Text(
                      'لايوجد نتائج',
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Signature for the [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// SearchToolbar widget
class SearchToolbar extends StatefulWidget {
  ///it describe the search toolbar constructor
  SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    Key? key,
  }) : super(key: key);

  /// Indicates whether the tooltip for the search toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback? onTap;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  int _searchTextLength = 0;

  /// Indicates whether search toolbar items need to be shown or not.
  bool _showItem = false;

  /// Indicates whether search toast need to be shown or not.
  bool _showToast = false;

  ///An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  ///An object that is used to obtain keyboard focus and to handle keyboard events.
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode?.dispose();
    super.dispose();
  }

  ///Clear the text search result
  void clearSearch() {
    _pdfTextSearchResult.clear();
  }

  ///Display the Alert dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(0),
          title: Text('نتائج البحث'),
          content: Container(
              width: 328.0,
              child: Text(
                  'ليس هناك نتائج اخرى يمكنك البحث من جديد')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.nextInstance();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'نعم',
                style: TextStyle(
                    color: Color(0x00000000).withOpacity(0.87),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.clear();
                  _editingController.clear();
                  _showItem = false;
                  focusNode?.requestFocus();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'لا',
                style: TextStyle(
                    color: Color(0x00000000).withOpacity(0.87),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0x00000000).withOpacity(0.54),
              size: 24,
            ),
            onPressed: () {
              widget.onTap?.call('Cancel Search');
              _editingController.clear();
              _pdfTextSearchResult.clear();
            },
          ),
        ),
        Flexible(
          child: TextFormField(
            style: TextStyle(
                color: Color(0x00000000).withOpacity(0.87), fontSize: 16),
            enableInteractiveSelection: false,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            controller: _editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Find...',
              hintStyle: TextStyle(color: Color(0x00000000).withOpacity(0.34)),
            ),
            onChanged: (text) {
              if (_searchTextLength < _editingController.value.text.length) {
                setState(() {});
                _searchTextLength = _editingController.value.text.length;
              }
              if (_editingController.value.text.length < _searchTextLength) {
                setState(() {
                  _showItem = false;
                });
              }
            },
            onFieldSubmitted: (String value) async {
              _pdfTextSearchResult =
              await widget.controller!.searchText(_editingController.text);
              if (_pdfTextSearchResult.totalInstanceCount == 0) {
                widget.onTap?.call('noResultFound');
              } else {
                setState(() {
                  _showItem = true;
                });
              }
            },
          ),
        ),
        Visibility(
          visible: _editingController.text.isNotEmpty,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Color.fromRGBO(0, 0, 0, 0.54),
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _editingController.clear();
                  _pdfTextSearchResult.clear();
                  widget.controller!.clearSelection();
                  _showItem = false;
                  focusNode!.requestFocus();
                });
                widget.onTap!.call('Clear Text');
              },
              tooltip: widget.showTooltip ? 'Clear Text' : null,
            ),
          ),
        ),
        Visibility(
          visible: _showItem,
          child: Row(
            children: [
              Text(
                '${_pdfTextSearchResult.currentInstanceIndex}',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Text(
                ' of ',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Text(
                '${_pdfTextSearchResult.totalInstanceCount}',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: Color.fromRGBO(0, 0, 0, 0.54),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _pdfTextSearchResult.previousInstance();
                    });
                    widget.onTap!.call('Previous Instance');
                  },
                  tooltip: widget.showTooltip ? 'Previous' : null,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Color.fromRGBO(0, 0, 0, 0.54),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_pdfTextSearchResult.currentInstanceIndex ==
                          _pdfTextSearchResult.totalInstanceCount &&
                          _pdfTextSearchResult.currentInstanceIndex != 0 &&
                          _pdfTextSearchResult.totalInstanceCount != 0) {
                        _showSearchAlertDialog(context);
                      } else {
                        widget.controller!.clearSelection();
                        _pdfTextSearchResult.nextInstance();
                      }
                    });
                    widget.onTap!.call('Next Instance');
                  },
                  tooltip: widget.showTooltip ? 'Next' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}