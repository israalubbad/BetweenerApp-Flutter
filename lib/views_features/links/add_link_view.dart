import 'package:betweener_app/core/helpers/context_extenssion.dart';
import 'package:betweener_app/models/link_response_model.dart';
import 'package:betweener_app/views_features/main_app_view.dart';
import 'package:betweener_app/views_features/widgets/custom_text_form_field.dart';
import 'package:betweener_app/views_features/widgets/secondary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/api_response.dart';
import '../../core/util/constants.dart';
import '../../view_models/link_provider.dart';

class AddLinkView extends StatefulWidget {
  static const id = '/addLink';
  final LinkElement? link;
  const AddLinkView({super.key, this.link });

  @override
  State<AddLinkView> createState() => _AddLinkViewState();
}

class _AddLinkViewState extends State<AddLinkView> {
  late TextEditingController _titleController;
  late TextEditingController _linkController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.link?.title );
    _linkController = TextEditingController(text: widget.link?.link);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        backgroundColor: kLightPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                CustomTextFormField(
                  label: 'ttile',
                  hint: 'snapshout',
                  controller: _titleController,
                  validator: (title) {
                    if (title == null || title.isEmpty) {
                      return 'please enter the title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  label: 'link',
                  hint: 'http://example.com',
                  controller: _linkController,
                  validator: (link) {
                    if (link == null || link.isEmpty) {
                      return 'please enter the link';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 50),
              SecondaryButtonWidget(
                width: 140,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    _save();
                  }
                },
                text: title,
              ),
              ],
            ),
          ),
        )
    );
  }
  Future<void> _save() async {
    final provider = Provider.of<LinkProvider>(context, listen: false);
    final link = linkData;

    if (isUpdateProduct) {
      await provider.updateLink(link);
    } else {
      await provider.addLink(link);
    }
    final status = isUpdateProduct ? provider.updateStatus : provider.addStatus;
    print(status.message);
    context.showSnackBar(
      message: status.message ?? (isUpdateProduct ? "Update Success" : "Add Success"),
      error: status.status != Status.COMPLETED,
    );

    if (status.status == Status.COMPLETED && status.data == true) {
      if (isUpdateProduct) {

        Navigator.pop(context);
      } else {
        clear();
      }
    }
  }


  LinkElement get linkData {
    LinkElement link = LinkElement();
    link.title = _titleController.text;
    link.link = _linkController.text;
    if (isUpdateProduct) {
      link.id = widget.link!.id;
    }
    return link;

  }

  void clear(){
    _titleController.clear();
    _linkController.clear();

  }

  bool get isUpdateProduct => widget.link != null ;
  String get title => isUpdateProduct
      ? 'Update Link'
      : 'Add Link' ;


}
