import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';
import 'package:texmunimx/common_widgets/custom_dropdown.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/common_widgets/password_input.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/controllers/user_controller.dart';
import 'package:texmunimx/models/roles_model.dart';
import 'package:texmunimx/models/user_list_response.dart';
import 'package:texmunimx/screens/users/widgets/user_active_switch.dart';
import 'package:texmunimx/utils/app_colors.dart';

class CreateUsersScreen extends StatefulWidget {
  final UserModel? user;
  const CreateUsersScreen({super.key, this.user});

  @override
  State<CreateUsersScreen> createState() => _CreateUsersScreenState();
}

class _CreateUsersScreenState extends State<CreateUsersScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isActive = true.obs;
  RxInt selectedRoleId = (-1).obs;

  UserController userController = Get.find<UserController>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userController.updateRoles();
    setUserData();
  }

  void setUserData() {
    if (widget.user != null) {
      nameController.text = widget.user!.fullname;
      emailController.text = widget.user!.email;
      phoneController.text = widget.user!.mobile;
      selectedRoleId.value = widget.user!.userType;
      isActive.value = widget.user!.isActive;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user != null ? 'edit_user'.tr : 'add_user'.tr),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: Colors.black26, width: 0.50),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => CustomDropdown<RolesModel>(
                            title: 'user_role'.tr,
                            isRequired: true,
                            selectedValue: selectedRoleId.value == -1
                                ? null
                                : userController.userRole.firstWhere(
                                    (role) => role.id == selectedRoleId.value,
                                    orElse: () => RolesModel(id: -1, type: ''),
                                  ),
                            items: userController.userRole,
                            onChanged: (RolesModel? newValue) {
                              if (newValue != null) {
                                selectedRoleId.value = newValue.id;
                              } else {
                                selectedRoleId.value = -1; // Reset selection
                              }
                            },
                            itemLabelBuilder: (RolesModel item) => item.type,
                            placeholderText: 'select_role'.tr,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildInputField(
                          label: 'name'.tr,
                          hintText: 'enter_name'.tr,
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        _buildInputField(
                          label: 'email'.tr,
                          hintText: 'enter_email'.tr,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            // Simple email validation
                            if (!GetUtils.isEmail(value.trim())) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        _buildPhoneField(
                          label: 'phone'.tr,
                          hintText: 'mobile_number'.tr,
                          controller: phoneController,
                        ),
                        _buildPassword(
                          controller: passwordController,
                          hintText: 'enter_password'.tr,
                        ),
                        Obx(
                          () => UserActiveSwitch(
                            isActive: isActive.value,
                            onChanged: (value) {
                              isActive.value = value;
                            },
                          ),
                        ),

                        SizedBox(height: 10),
                        Obx(
                          () => userController.isLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    CustomBtn(
                                      title: widget.user != null
                                          ? 'update'.tr
                                          : 'create'.tr,
                                      onTap: () {
                                        // Handle create user logic here
                                        if (selectedRoleId.value == -1) {
                                          showErrorSnackbar(
                                            'Please select a role',
                                          );
                                          return;
                                        }

                                        if (formKey.currentState!.validate()) {
                                          // All fields are valid, proceed with user creation
                                          // You can access the input values using the controllers
                                          String name = nameController.text
                                              .trim();
                                          String email = emailController.text
                                              .trim();
                                          String phone = phoneController.text
                                              .trim();
                                          String password = passwordController
                                              .text
                                              .trim();
                                          bool activeStatus = isActive.value;
                                          int roleId = selectedRoleId.value;

                                          if (widget.user != null) {
                                            userController.updateUser(
                                              userId: widget.user!.id
                                                  .toString(),
                                              name: name,
                                              email: email,
                                              phone: phone,
                                              password: password,
                                              role: roleId,
                                              isActive: activeStatus,
                                            );
                                          } else {
                                            userController.createUser(
                                              name: name,
                                              email: email,
                                              phone: phone,
                                              password: password,
                                              role: roleId,
                                              isActive: activeStatus,
                                            );
                                          }
                                        }
                                      },
                                    ),

                                    if (widget.user != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: CustomBtnRed(
                                          title: 'delete'.tr,
                                          isOutline: true,
                                          onTap: () {
                                            // Handle delete user logic here
                                            Get.defaultDialog(
                                              title: 'confirm'.tr,
                                              middleText:
                                                  'are_you_sure_you_want_to_delete_user'
                                                      .tr,
                                              //textCancel: 'no'.tr,
                                              textConfirm: 'delete'.tr,
                                              confirmTextColor: Colors.white,
                                              buttonColor: Colors.red,
                                              cancel: TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text('no'.tr),
                                              ),
                                              onConfirm: () {
                                                Get.back();
                                                userController.deleteUser(
                                                  userId: widget.user!.id
                                                      .toString(),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassword({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 6),

            Text(
              'password'.tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        PasswordTextField(
          controller: controller,
          validator: (value) {
            if (widget.user != null && value!.isEmpty) {
              // If editing an existing user and password is empty, it's valid
              return null;
            }
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        InputField(
          textEditingController: controller,
          hintText: hintText,
          onValidator: validator,
          textInputType: keyboardType,
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPhoneField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 6),
            Text(
              'phone'.tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              // Simple phone validation
              if (!GetUtils.isPhoneNumber(value.trim())) {
                return 'Please enter a valid phone number';
              }

              if (value.trim().length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
            textAlign: TextAlign.start,
            controller: controller,
            keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: 14),
            maxLength: 10,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: '',
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black38),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.mainColor),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
