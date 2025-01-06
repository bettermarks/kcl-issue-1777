# Example code for [kcl issue 1777](https://github.com/kcl-lang/kcl/issues/1777)

The difference of the broken to the working example is just the place where `DefaultLoginMixin` is defined:

```bash
diff -ruN working broken
```

```diff
diff -ruN working/kcl.mod broken/kcl.mod
--- working/kcl.mod	2025-04-03 22:22:25.551723880 +0200
+++ broken/kcl.mod	2025-04-03 22:23:06.855225766 +0200
@@ -1,4 +1,4 @@
 [package]
-name = "working"
+name = "broken"
 edition = "v0.11.1"
 version = "0.0.1"
diff -ruN working/main.k broken/main.k
--- working/main.k	2025-01-06 16:37:30.669262974 +0100
+++ broken/main.k	2025-04-03 22:23:27.456477133 +0200
@@ -1,16 +1,8 @@
-protocol LoginProtocol:
-    a_url: str
-    b_url: str
-
-mixin DefaultLoginMixin for LoginProtocol:
-    # INFO: If no a_url, b_url is defined in the final schema, we apply the
-    # value from _default_login
-    a_url: str = a_url or _default_login.a_url
-    b_url: str = b_url or _default_login.b_url
+import mod
 
 schema Config:
     mixin [
-        DefaultLoginMixin
+        mod.DefaultLoginMixin
     ]
 
 schema Stage:
diff -ruN working/mod.k broken/mod.k
--- working/mod.k	1970-01-01 01:00:00.000000000 +0100
+++ broken/mod.k	2025-01-06 16:35:46.357846807 +0100
@@ -0,0 +1,10 @@
+protocol LoginProtocol:
+    a_url: str
+    b_url: str
+
+mixin DefaultLoginMixin for LoginProtocol:
+    # INFO: If no a_url, b_url is defined in the final schema, we apply the
+    # value from _default_login
+    a_url: str = a_url or _default_login.a_url
+    b_url: str = b_url or _default_login.b_url
+
```

## Run the working example

```bash
kcl run working
```

Output is:

```
ci00:
  provider_1:
    a_url: https://default.a_url
    b_url: https://default.b_url
  provider_2:
    a_url: https://custom.a_url
    b_url: https://default.b_url
config:
  a_url: https://must.be.set.a_url
  b_url: https://must.be.set.b_url
```

## Run the broken example

```bash
kcl run broken
```

Output is:

```
EvaluationError
 --> /home/olli/code/bm/kcl-issue-1777/broken/mod.k:8:1
  |
8 |     a_url: str = a_url or _default_login.a_url
  |  invalid value 'UndefinedType' to load attribute 'a_url'
  |
```
